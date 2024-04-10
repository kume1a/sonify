import 'package:common_models/common_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../features/spotifyauth/api/spotify_access_token_provider.dart';

part 'import_spotify_playlists_state.freezed.dart';

@freezed
class ImportSpotifyPlaylistsState with _$ImportSpotifyPlaylistsState {
  const factory ImportSpotifyPlaylistsState({
    required SimpleDataState<bool> isSpotifyPlaylistsImported,
    required ActionState<ActionFailure> importSpotifyPlaylistsState,
  }) = _ImportSpotifyPlaylistsState;

  factory ImportSpotifyPlaylistsState.initial() => ImportSpotifyPlaylistsState(
        isSpotifyPlaylistsImported: SimpleDataState.idle(),
        importSpotifyPlaylistsState: ActionState.idle(),
      );
}

extension ImportSpotifyPlaylistsStateX on BuildContext {
  ImportSpotifyPlaylistsCubit get importSpotifyPlaylistsCubit => read<ImportSpotifyPlaylistsCubit>();
}

@injectable
class ImportSpotifyPlaylistsCubit extends Cubit<ImportSpotifyPlaylistsState> {
  ImportSpotifyPlaylistsCubit(
    this._userSyncDatumRepository,
    this._playlistRepository,
    this._spotifyAccessTokenProvider,
  ) : super(ImportSpotifyPlaylistsState.initial()) {
    _init();
  }

  final UserSyncDatumRepository _userSyncDatumRepository;
  final PlaylistRemoteService _playlistRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;

  Future<void> _init() async {
    await _checkIfSpotifyUserPlaylistsImported();
  }

  Future<void> onRefreshSpotifyPlaylistImportStatus() {
    return _checkIfSpotifyUserPlaylistsImported();
  }

  Future<void> onImportSpotifyPlaylists() async {
    final isSpotifyPlaylistsImported = state.isSpotifyPlaylistsImported.getOrNull;
    if (isSpotifyPlaylistsImported == null || isSpotifyPlaylistsImported) {
      Logger.root.warning('Spotify playlists import status not loaded or already imported');
      return;
    }

    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.executing()));

    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      emit(state.copyWith(importSpotifyPlaylistsState: ActionState.failed(ActionFailure.unknown)));

      Logger.root.warning('Spotify access token is null, cannot import playlists');
      return;
    }

    final res = await _playlistRepository.importSpotifyUserPlaylists(spotifyAccessToken: spotifyAccessToken);

    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.fromEither(res)));
  }

  Future<void> _checkIfSpotifyUserPlaylistsImported() async {
    emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.loading()));

    await _userSyncDatumRepository.getAuthUserSyncDatum().awaitFold(
          (l) => emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.failure())),
          (r) => emit(state.copyWith(
            isSpotifyPlaylistsImported: SimpleDataState.success(r.spotifyLastSyncedAt != null),
          )),
        );
  }
}
