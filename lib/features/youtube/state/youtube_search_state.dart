import 'package:common_models/common_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/debounce.dart';
import '../api/youtube_api.dart';

typedef YoutubeSearchState = DataState<Unit, List<String>>;

extension YoutubeSearchCubitX on BuildContext {
  YoutubeSearchCubit get youtubeSearchCubit => read<YoutubeSearchCubit>();
}

@injectable
class YoutubeSearchCubit extends Cubit<YoutubeSearchState> {
  YoutubeSearchCubit(
    this._youtubeApi,
  ) : super(YoutubeSearchState.idle());

  final YoutubeApi _youtubeApi;

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

  Future<void> onSearchSuggestionPressed(String suggestion) async {}
}
