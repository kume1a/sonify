import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/search_suggestions_page.dart';

typedef YoutubeSearchState = DataState<NetworkCallError, YoutubeSearchSuggestions>;

extension YoutubeSearchCubitX on BuildContext {
  YoutubeSearchCubit get youtubeSearchCubit => read<YoutubeSearchCubit>();
}

@injectable
class YoutubeSearchCubit extends Cubit<YoutubeSearchState> {
  YoutubeSearchCubit(
    this._youtubeRemoteRepository,
    this._pageNavigator,
  ) : super(YoutubeSearchState.idle());

  final YoutubeRemoteRepository _youtubeRemoteRepository;
  final PageNavigator _pageNavigator;

  final _debounce = Debounce.fromMilliseconds(400);

  final searchQueryController = TextEditingController();

  void init(SearchSuggestionsPageArgs args) {
    final initialValue = args.initialValue ?? '';

    if (initialValue.isNotEmpty) {
      searchQueryController.text = initialValue;
      onSearchQueryChanged(initialValue);
    }
  }

  Future<void> onSearchQueryChanged(String value) async {
    _debounce.execute(() async {
      emit(YoutubeSearchState.loading());

      final res = await _youtubeRemoteRepository.getYoutubeSuggestions(keyword: value);

      emit(YoutubeSearchState.fromEither(res));
    });
  }

  void onSearchSuggestionFillPressed(String value) {
    searchQueryController.text = value;
  }

  @override
  Future<void> close() {
    _debounce.dispose();
    searchQueryController.dispose();

    return super.close();
  }

  void onSearchSuggestionPressed(String suggestion) {
    final result = YoutubeSearchResult(query: suggestion);

    _pageNavigator.pop(result: result);
  }

  void onSubmitted(String query) {
    final result = YoutubeSearchResult(query: query);

    _pageNavigator.pop(result: result);
  }
}
