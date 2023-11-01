import 'package:common_models/common_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/util/debounce.dart';
import '../api/youtube_api.dart';
import '../model/youtube_search_result.dart';

typedef YoutubeSearchState = DataState<Unit, List<String>>;

extension YoutubeSearchCubitX on BuildContext {
  YoutubeSearchCubit get youtubeSearchCubit => read<YoutubeSearchCubit>();
}

@injectable
class YoutubeSearchCubit extends Cubit<YoutubeSearchState> {
  YoutubeSearchCubit(
    this._youtubeApi,
    this._pageNavigator,
  ) : super(YoutubeSearchState.idle());

  final YoutubeApi _youtubeApi;
  final PageNavigator _pageNavigator;

  final Debounce _debounce = Debounce.fromMilliseconds(400);

  Future<void> onSearchQueryChanged(String value) async {
    _debounce.execute(() async {
      emit(YoutubeSearchState.loading());

      final res = await _youtubeApi.searchSuggestions(value);

      emit(YoutubeSearchState.success(res));
    });
  }

  @override
  Future<void> close() {
    _debounce.dispose();

    return super.close();
  }

  Future<void> onSearchSuggestionPressed(String suggestion) async {
    final result = YoutubeSearchResult(query: suggestion);

    _pageNavigator.pop(result: result);
  }
}
