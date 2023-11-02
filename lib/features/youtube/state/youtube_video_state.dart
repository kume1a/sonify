import 'package:common_models/common_models.dart';
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
    required DataState<Unit, Video> video,
  }) = _YoutubeVideoState;

  factory YoutubeVideoState.initial() => YoutubeVideoState(
        video: DataState.idle(),
      );
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
    emit(state.copyWith(video: DataState.loading()));

    final videoRes = await _youtubeApi.getVideo(videoId);

    final videoStream = videoRes.first;
    final video = videoRes.second;

    emit(state.copyWith(
      videoUri: videoStream.url,
      video: DataState.success(video),
    ));
  }
}
