import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/playlist_page.dart';
import '../../../pages/search_suggestions_page.dart';
import '../../../shared/dialog/dialog_manager.dart';
import '../../../shared/ui/toast_notifier.dart';
import '../../spotifyauth/api/spotify_access_token_provider.dart';

typedef SpotifySearchState = DataState<NetworkCallError, SpotifySearchResult>;

extension SpotifySearchCubitX on BuildContext {
  SpotifySearchCubit get spotifySearchCubit => read<SpotifySearchCubit>();
}

@injectable
class SpotifySearchCubit extends Cubit<SpotifySearchState> {
  SpotifySearchCubit(
    this._spotifyRemoteRepository,
    this._spotifyAccessTokenProvider,
    this._dialogManager,
    this._toastNotifier,
    this._pageNavigator,
  ) : super(SpotifySearchState.idle());

  final SpotifyRemoteRepository _spotifyRemoteRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;
  final DialogManager _dialogManager;
  final ToastNotifier _toastNotifier;
  final PageNavigator _pageNavigator;

  final Debounce _debounce = Debounce.fromMilliseconds(400);

  void init(SearchSuggestionsPageArgs args) {
    final value = args.initialValue ?? '';

    if (value.isNotEmpty) {
      onSearchQueryChanged(value);
    }
  }

  Future<void> onSearchQueryChanged(String value) async {
    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      Logger.root.warning('SpotifySearchCubit.onSearchQueryChanged: Spotify access token is null');
      return;
    }

    _debounce.execute(() async {
      emit(SpotifySearchState.loading());

      final res = await _spotifyRemoteRepository.search(
        keyword: value,
        spotifyAccessToken: spotifyAccessToken,
      );

      emit(SpotifySearchState.fromEither(res));
    });
  }

  @override
  Future<void> close() {
    _debounce.dispose();

    return super.close();
  }

  Future<void> onSearchedPlaylistPressed(SpotifySearchResultPlaylist playlistSearchResult) async {
    if (playlistSearchResult.playlistId != null) {
      final args = PlaylistPageArgs(playlistId: playlistSearchResult.playlistId!);

      _pageNavigator.toPlaylist(args);
      return;
    }

    final didConfirm = await _dialogManager.showConfirmationDialog(
      caption: (l) => l.confirmImportSpotifyPlaylistCaption,
    );

    if (!didConfirm) {
      return;
    }

    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      Logger.root.warning('SpotifySearchCubit.onSearchedPlaylistPressed: Spotify access token is null');
      return;
    }

    final res = await _spotifyRemoteRepository.importSpotifyPlaylist(
      spotifyPlaylistId: playlistSearchResult.spotifyId,
      spotifyAccessToken: spotifyAccessToken,
    );

    return res.fold(
      (error) {
        _toastNotifier.error(
          description: (l) => l.failedToImportSpotifyPlaylist,
        );

        return Future.value();
      },
      (r) async {
        _toastNotifier.success(
          description: (l) => l.importingSpotifyPlaylist,
        );

        final newState = state.map((data) {
          final newPlaylists = data.playlists.replace(
            (e) => e.spotifyId == playlistSearchResult.spotifyId,
            (searchedPlaylist) => searchedPlaylist.copyWith(playlistId: r.id),
          );

          return data.copyWith(playlists: newPlaylists);
        });

        emit(newState);
      },
    );
  }
}
