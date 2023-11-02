import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../api/youtube_api.dart';

part 'youtube_video_state.freezed.dart';

@freezed
class YoutubeVideoState with _$YoutubeVideoState {
  const factory YoutubeVideoState({
    String? videoId,
  }) = _YoutubeVideoState;

  factory YoutubeVideoState.initial() => const YoutubeVideoState();
}

@injectable
class YoutubeVideoCubit extends Cubit<YoutubeVideoState> {
  YoutubeVideoCubit(
    this._youtubeApi,
  ) : super(YoutubeVideoState.initial());

  final YoutubeApi _youtubeApi;

  void init(String videoId) {
    Logger.root.info('init called');
    emit(state.copyWith(videoId: videoId));

    _loadVideo();
  }

  Future<void> _loadVideo() async {
    if (state.videoId == null) {
      return;
    }

    final video = await _youtubeApi.getVideoStream(state.videoId!);

    Logger.root.info(video.url);
  }
}
