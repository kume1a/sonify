import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

typedef SearchMyLibraryState = SimpleDataState<List<UserAudio>>;

extension SearchMyLibraryCubitX on BuildContext {
  SearchMyLibraryCubit get searchMyLibraryCubit => read<SearchMyLibraryCubit>();
}

@injectable
class SearchMyLibraryCubit extends Cubit<SearchMyLibraryState> {
  SearchMyLibraryCubit(
    this._userAudioLocalRepository,
    this._authUserInfoProvider,
  ) : super(SearchMyLibraryState.idle());

  final UserAudioLocalRepository _userAudioLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  final _debounce = Debounce.fromMilliseconds(500);

  @override
  Future<void> close() async {
    _debounce.dispose();

    return super.close();
  }

  Future<void> onSearchQueryChanged(String query) async {
    final authUserId = await _authUserInfoProvider.getId();

    if (authUserId == null) {
      Logger.root.warning('User id is null, cannot search local audio files.');
      return;
    }

    _debounce.execute(() async {
      emit(SearchMyLibraryState.loading());

      final res = await _userAudioLocalRepository.getAll(
        userId: authUserId,
        searchQuery: query,
        sort: AudioSort.title,
      );

      emit(SearchMyLibraryState.fromResult(res));
    });
  }
}
