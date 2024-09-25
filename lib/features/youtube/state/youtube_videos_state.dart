import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/search_suggestions_page.dart';
import '../../../pages/youtube_video_page.dart';

part 'youtube_videos_state.freezed.dart';

@freezed
class YoutubeVideosState with _$YoutubeVideosState {
  const factory YoutubeVideosState({
    required SimpleDataState<List<Video>> searchResults,
    required String searchQuery,
  }) = _YoutubeVideosState;

  factory YoutubeVideosState.initial() => YoutubeVideosState(
        searchResults: SimpleDataState.idle(),
        searchQuery: '',
      );
}

extension YoutubeHomeVideosCubitX on BuildContext {
  YoutubeVideosCubit get youtubeVideosCubit => read<YoutubeVideosCubit>();
}

@injectable
class YoutubeVideosCubit extends Cubit<YoutubeVideosState> {
  YoutubeVideosCubit(
    this._youtubeRemoteRepository,
    this._pageNavigator,
  ) : super(YoutubeVideosState.initial());

  final YoutubeRemoteRepository _youtubeRemoteRepository;
  final PageNavigator _pageNavigator;

  Future<void> onSearchPressed() async {
    final args = SearchSuggestionsPageArgs(initialValue: state.searchQuery);

    final searchRes = await _pageNavigator.toSearchSuggestions(args);

    final searchQuery = searchRes?.query;

    if (searchQuery == null) {
      return;
    }

    emit(state.copyWith(
      searchResults: SimpleDataState.loading(),
      searchQuery: searchQuery,
    ));

    final res = await _youtubeRemoteRepository.search(query: searchQuery);

    emit(state.copyWith(searchResults: SimpleDataState.fromResult(res)));
  }

  Future<void> onClearSearch() async {
    emit(state.copyWith(
      searchQuery: '',
      searchResults: SimpleDataState.idle(),
    ));
  }

  Future<void> onVideoPressed(String videoId) async {
    final args = YoutubeVideoPageArgs(videoId: videoId);

    _pageNavigator.toYoutubeVideo(args);
  }
}
