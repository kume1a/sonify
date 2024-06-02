import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/spotifyauth/api/spotify_access_token_provider.dart';
import '../model/event_spotify_playlists_imported.dart';

part 'import_spotify_playlists_state.freezed.dart';

@freezed
class ImportSpotifyPlaylistsState with _$ImportSpotifyPlaylistsState {
  const factory ImportSpotifyPlaylistsState({
    required SimpleDataState<bool> isSpotifyPlaylistsImported,
    required ActionState<NetworkCallError> importSpotifyPlaylistsState,
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
    this._userSyncDatumLocalRepository,
    this._eventBus,
  ) : super(ImportSpotifyPlaylistsState.initial()) {
    _init();
  }

  final UserSyncDatumRemoteRepository _userSyncDatumRepository;
  final PlaylistRemoteRepository _playlistRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;
  final UserSyncDatumLocalRepository _userSyncDatumLocalRepository;
  final EventBus _eventBus;

  Future<void> _init() {
    return _checkIfSpotifyUserPlaylistsImported();
  }

  Future<void> onRefreshSpotifyPlaylistImportStatus() {
    return _checkIfSpotifyUserPlaylistsImported();
  }

  Future<void> onImportSpotifyPlaylists() async {
    final isSpotifyPlaylistsImported = state.isSpotifyPlaylistsImported.getOrNull;
    if (isSpotifyPlaylistsImported == null) {
      Logger.root.warning('Spotify playlists import status not loaded');
      return;
    }

    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.executing()));

    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      emit(state.copyWith(importSpotifyPlaylistsState: ActionState.failed(NetworkCallError.unknown)));

      Logger.root.warning('Spotify access token is null, cannot import playlists');
      return;
    }

    final res = await _playlistRepository.importSpotifyUserPlaylists(spotifyAccessToken: spotifyAccessToken);

    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.fromEither(res)));

    res.ifRight((r) => _eventBus.fire(EventSpotifyPlaylistsImported()));
  }

  Future<void> _checkIfSpotifyUserPlaylistsImported() async {
    emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.loading()));

    final remoteUserSyncDatumRes = await _userSyncDatumRepository.getAuthUserSyncDatum();

    if (remoteUserSyncDatumRes.isRight) {
      final isSpotifyPlaylistsImported = remoteUserSyncDatumRes.rightOrThrow.spotifyLastSyncedAt != null;

      emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.success(isSpotifyPlaylistsImported)));

      await _userSyncDatumLocalRepository.writeAuthUserSyncDatum(remoteUserSyncDatumRes.rightOrThrow);

      return;
    }

    await _userSyncDatumLocalRepository.getAuthUserSyncDatum().awaitFold(
      () => emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.failure())),
      (r) {
        if (r == null) {
          emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.failure()));
          return;
        }

        final isSpotifyPlaylistsImported = r.spotifyLastSyncedAt != null;

        emit(state.copyWith(isSpotifyPlaylistsImported: SimpleDataState.success(isSpotifyPlaylistsImported)));
      },
    );
  }
}
