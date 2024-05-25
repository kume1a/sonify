import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../download_file/model/downloads_event.dart';

part 'youtube_video_state.freezed.dart';

@freezed
class YoutubeVideoState with _$YoutubeVideoState {
  const factory YoutubeVideoState({
    Uri? videoUri,
    required SimpleDataState<Video> video,
    required SimpleDataState<MuxedStreamInfo> highQualityMuxedStreamInfo,
    required ActionState<DownloadYoutubeAudioError> downloadAudioState,
    required bool isDownloadAvailable,
  }) = _YoutubeVideoState;

  factory YoutubeVideoState.initial() => YoutubeVideoState(
        video: SimpleDataState.idle(),
        highQualityMuxedStreamInfo: SimpleDataState.idle(),
        downloadAudioState: ActionState.idle(),
        isDownloadAvailable: false,
      );
}

extension YoutubeVideoCubitX on BuildContext {
  YoutubeVideoCubit get youtubeVideoCubit => read<YoutubeVideoCubit>();
}

@injectable
class YoutubeVideoCubit extends Cubit<YoutubeVideoState> {
  YoutubeVideoCubit(
    this._youtubeRemoteRepository,
    this._eventBus,
  ) : super(YoutubeVideoState.initial());

  final YoutubeRemoteRepository _youtubeRemoteRepository;
  final EventBus _eventBus;

  void init(String videoId) {
    Logger.root.info('Loading Youtube video, videoId = $videoId');

    _loadVideo(videoId);
  }

  Future<void> _loadVideo(String videoId) async {
    emit(state.copyWith(
      video: SimpleDataState.loading(),
      highQualityMuxedStreamInfo: SimpleDataState.loading(),
    ));

    final video = await _youtubeRemoteRepository.getVideo(videoId: videoId);
    final highestBitrateVideo =
        await _youtubeRemoteRepository.getHighestQualityMuxedStreamInfo(videoId: videoId);

    emit(state.copyWith(
      videoUri: highestBitrateVideo.dataOrNull?.url,
      video: SimpleDataState.fromResult(video),
      highQualityMuxedStreamInfo: SimpleDataState.fromResult(highestBitrateVideo),
      isDownloadAvailable: video.isSuccess,
    ));
  }

  Future<void> onDownloadAudio() async {
    final video = state.video.getOrNull;
    if (video == null) {
      return;
    }

    emit(state.copyWith(downloadAudioState: ActionState.executing()));

    _youtubeRemoteRepository.downloadYoutubeAudio(videoId: video.id.value).awaitFold(
      (l) async {
        emit(state.copyWith(downloadAudioState: ActionState.failed(l)));
        await _resetDownloadAudioState();
      },
      (r) async {
        _eventBus.fire(DownloadsEvent.enqueueUserAudio(r));

        emit(state.copyWith(downloadAudioState: ActionState.executed()));
        await _resetDownloadAudioState();
      },
    );
  }

  Future<void> _resetDownloadAudioState() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => emit(state.copyWith(downloadAudioState: ActionState.idle())),
    );
  }
}
