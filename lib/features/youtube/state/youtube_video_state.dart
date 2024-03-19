import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../entities/audio/model/remote_audio_file.dart';
import '../../../shared/util/assemble_resource_url.dart';
import '../../download_file/model/downloads_event.dart';

part 'youtube_video_state.freezed.dart';

@freezed
class YoutubeVideoState with _$YoutubeVideoState {
  const factory YoutubeVideoState({
    Uri? videoUri,
    required SimpleDataState<Video> video,
    required SimpleDataState<MuxedStreamInfo> highQualityMuxedStreamInfo,
    required ActionState<ActionFailure> downloadAudioState,
  }) = _YoutubeVideoState;

  factory YoutubeVideoState.initial() => YoutubeVideoState(
        video: SimpleDataState.idle(),
        highQualityMuxedStreamInfo: SimpleDataState.idle(),
        downloadAudioState: ActionState.idle(),
      );
}

extension YoutubeVideoCubitX on BuildContext {
  YoutubeVideoCubit get youtubeVideoCubit => read<YoutubeVideoCubit>();
}

@injectable
class YoutubeVideoCubit extends Cubit<YoutubeVideoState> {
  YoutubeVideoCubit(
    this._youtubeRepository,
    this._eventBus,
    this._audioRepository,
  ) : super(YoutubeVideoState.initial());

  final YoutubeRepository _youtubeRepository;
  final EventBus _eventBus;
  final AudioRepository _audioRepository;

  void init(String videoId) {
    _loadVideo(videoId);
  }

  Future<void> _loadVideo(String videoId) async {
    emit(state.copyWith(
      video: SimpleDataState.loading(),
      highQualityMuxedStreamInfo: SimpleDataState.loading(),
    ));

    final video = await _youtubeRepository.getVideo(videoId);
    final highestBitrateVideo = await _youtubeRepository.getHighestQualityMuxedStreamInfo(videoId);

    emit(state.copyWith(
      videoUri: highestBitrateVideo.url,
      video: SimpleDataState.success(video),
      highQualityMuxedStreamInfo: SimpleDataState.success(highestBitrateVideo),
    ));
  }

  Future<void> onDownloadAudio() async {
    final video = state.video.getOrNull;
    if (video == null) {
      return;
    }

    _audioRepository.downloadYoutubeAudio(video.id.value).awaitFold(
      (l) => emit(state.copyWith(downloadAudioState: ActionState.failed(l))),
      (r) {
        final remoteAudioFile = RemoteAudioFile(
          title: video.title,
          uri: Uri.parse(assembleResourceUrl(r.path)),
          sizeInBytes: r.sizeInBytes ?? 0,
          author: video.author,
          imageUri: Uri.tryParse(assembleResourceUrl(r.thumbnailPath)),
          userId: r.userId,
          youtubeVideoId: r.youtubeVideoId,
        );

        _eventBus.fire(DownloadsEvent.enqueueRemoteAudioFile(remoteAudioFile));
      },
    );
  }
}
