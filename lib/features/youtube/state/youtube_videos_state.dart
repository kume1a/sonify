import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/youtube_video_page.dart';

part 'youtube_videos_state.freezed.dart';

@freezed
class YoutubeVideosState with _$YoutubeVideosState {
  const factory YoutubeVideosState({
    required DataState<FetchFailure, List<Video>> searchResults,
    required String searchQuery,
  }) = _YoutubeVideosState;

  factory YoutubeVideosState.initial() => YoutubeVideosState(
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
    this._youtubeRepository,
    this._pageNavigator,
  ) : super(YoutubeVideosState.initial());

  final YoutubeRepository _youtubeRepository;
  final PageNavigator _pageNavigator;

  Future<void> onSearchPressed() async {
    final searchRes = await _pageNavigator.toYoutubeSearch();

    final searchQuery = searchRes?.query;

    if (searchQuery == null) {
      return;
    }

    emit(state.copyWith(
      searchResults: DataState.loading(),
      searchQuery: searchQuery,
    ));

    final res = await _youtubeRepository.search(searchQuery);

    emit(state.copyWith(searchResults: DataState.success(res)));
  }

  Future<void> onClearSearch() async {
    emit(state.copyWith(
      searchQuery: '',
      searchResults: DataState.idle(),
    ));
  }

  Future<void> onVideoPressed(String videoId) async {
    final args = YoutubeVideoPageArgs(videoId: videoId);

    _pageNavigator.toYoutubeVideo(args);
  }
}
