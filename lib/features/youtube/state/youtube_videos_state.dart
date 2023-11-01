import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/youtube_video_page.dart';
import '../api/youtube_api.dart';
import '../model/youtube_music_home_dto.dart';

part 'youtube_videos_state.freezed.dart';

@freezed
class YoutubeVideosState with _$YoutubeVideosState {
  const factory YoutubeVideosState({
    required DataState<FetchFailure, YoutubeMusicHomeDto> musicHome,
    required DataState<FetchFailure, List<Video>> searchResults,
    required String searchQuery,
  }) = _YoutubeVideosState;

  factory YoutubeVideosState.initial() => YoutubeVideosState(
        musicHome: DataState.idle(),
        searchResults: DataState.idle(),
        searchQuery: '',
      );
}

extension YoutubeHomeVideosCubitX on BuildContext {
  YoutubeVideosCubit get youtubeVideosCubit => read<YoutubeVideosCubit>();
}

@injectable
class YoutubeVideosCubit extends Cubit<YoutubeVideosState> {
  YoutubeVideosCubit(
    this._youtubeApi,
    this._pageNavigator,
  ) : super(YoutubeVideosState.initial()) {
    _init();
  }

  final YoutubeApi _youtubeApi;
  final PageNavigator _pageNavigator;

  Future<void> _init() async {
    _loadVideos();
  }

  Future<void> onSearchPressed() async {
    final searchRes = await _pageNavigator.toYoutubeSearch();

    final searchQuery = searchRes?.query;

    if (searchQuery == null) {
      return;
    }

    emit(state.copyWith(
      musicHome: DataState.idle(),
      searchResults: DataState.loading(),
      searchQuery: searchQuery,
    ));

    final res = await _youtubeApi.search(searchQuery);

    emit(state.copyWith(searchResults: DataState.success(res)));
  }

  Future<void> onClearSearch() async {
    emit(state.copyWith(
      searchQuery: '',
      searchResults: DataState.idle(),
    ));

    await _loadVideos();
  }

  Future<void> _loadVideos() async {
    emit(state.copyWith(musicHome: DataState.loading()));
    final res = await _youtubeApi.getMusicHome();
    emit(state.copyWith(musicHome: DataState.fromEither(res)));
  }

  Future<void> onVideoPressed(String videoId) async {
    final args = YoutubeVideoPageArgs(videoId: videoId);

    _pageNavigator.toYoutubeVideo(args);
  }
}
