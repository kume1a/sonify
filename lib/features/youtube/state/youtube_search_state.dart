import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/util/debounce.dart';

typedef YoutubeSearchState = DataState<FetchFailure, YoutubeSearchSuggestions>;

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

  final Debounce _debounce = Debounce.fromMilliseconds(400);

  Future<void> onSearchQueryChanged(String value) async {
    _debounce.execute(() async {
      emit(YoutubeSearchState.loading());

      final res = await _youtubeRemoteRepository.getYoutubeSuggestions(keyword: value);

      emit(YoutubeSearchState.fromEither(res));
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
