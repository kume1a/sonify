import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/util/debounce.dart';

typedef SearchPlaylistAudiosState = SimpleDataState<List<PlaylistAudio>>;

extension SearchPlaylistAudiosCubitX on BuildContext {
  SearchPlaylistAudiosCubit get searchPlaylistAudiosCubit => read<SearchPlaylistAudiosCubit>();
}

@injectable
class SearchPlaylistAudiosCubit extends Cubit<SearchPlaylistAudiosState> {
  SearchPlaylistAudiosCubit(
    this._playlistAudioLocalRepository,
  ) : super(SearchPlaylistAudiosState.idle());

  final PlaylistAudioLocalRepository _playlistAudioLocalRepository;

  final _debounce = Debounce.fromMilliseconds(500);

  String? _playlistId;

  void init(String playlistId) {
    _playlistId = playlistId;
  }

  @override
  Future<void> close() async {
    _debounce.dispose();

    return super.close();
  }

  Future<void> onSearchQueryChanged(String query) async {
    if (_playlistId == null) {
      Logger.root.warning('Playlist id is null, cannot search playlist audio files.');
      return;
    }

    _debounce.execute(() async {
      emit(SearchPlaylistAudiosState.loading());

      final res = await _playlistAudioLocalRepository.getAllWithAudios(
        playlistId: _playlistId!,
        searchQuery: query,
      );

      emit(SearchPlaylistAudiosState.fromResult(res));
    });
  }
}
