import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../api/youtube_api.dart';

part 'youtube_video_state.freezed.dart';

@freezed
class YoutubeVideoState with _$YoutubeVideoState {
  const factory YoutubeVideoState({
    Uri? videoUri,
    required SimpleDataState<Video> video,
    required SimpleDataState<MuxedStreamInfo> highQualityMuxedStreamInfo,
    required SimpleDataState<List<AudioOnlyStreamInfo>> audioOnlyStreamInfos,
  }) = _YoutubeVideoState;

  factory YoutubeVideoState.initial() => YoutubeVideoState(
        video: SimpleDataState.idle(),
        highQualityMuxedStreamInfo: SimpleDataState.idle(),
        audioOnlyStreamInfos: SimpleDataState.idle(),
      );
}

extension YoutubeVideoCubitX on BuildContext {
  YoutubeVideoCubit get youtubeVideoCubit => read<YoutubeVideoCubit>();
}

@injectable
class YoutubeVideoCubit extends Cubit<YoutubeVideoState> {
  YoutubeVideoCubit(
    this._youtubeApi,
  ) : super(YoutubeVideoState.initial());

  final YoutubeApi _youtubeApi;

  void init(String videoId) {
    _loadVideo(videoId);
  }

  Future<void> _loadVideo(String videoId) async {
    emit(state.copyWith(
      video: SimpleDataState.loading(),
      highQualityMuxedStreamInfo: SimpleDataState.loading(),
      audioOnlyStreamInfos: SimpleDataState.loading(),
    ));

    final video = await _youtubeApi.getVideo(videoId);
    final audioOnlyStreams = await _youtubeApi.getAudioOnlyStreams(videoId);
    final highestBitrateVideo = await _youtubeApi.getHighestQualityMuxedStreamInfo(videoId);

    final sortedAudioOnlyStreams = audioOnlyStreams.toList()..sort((a, b) => a.bitrate.compareTo(b.bitrate));

    emit(state.copyWith(
      videoUri: highestBitrateVideo.url,
      video: SimpleDataState.success(video),
      highQualityMuxedStreamInfo: SimpleDataState.success(highestBitrateVideo),
      audioOnlyStreamInfos: SimpleDataState.success(sortedAudioOnlyStreams),
    ));
  }
}
