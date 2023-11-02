import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../api/youtube_api.dart';

part 'youtube_video_state.freezed.dart';

@freezed
class YoutubeVideoState with _$YoutubeVideoState {
  const factory YoutubeVideoState({
    Uri? videoUri,
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
    _loadVideo(videoId);
  }

  Future<void> _loadVideo(String videoId) async {
    final video = await _youtubeApi.getVideoStream(videoId);

    emit(state.copyWith(videoUri: video.url));
  }
}
