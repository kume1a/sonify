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
    required ActionState<NetworkCallError> importSpotifyPlaylistsState,
  }) = _ImportSpotifyPlaylistsState;

  factory ImportSpotifyPlaylistsState.initial() => ImportSpotifyPlaylistsState(
        importSpotifyPlaylistsState: ActionState.idle(),
      );
}

extension ImportSpotifyPlaylistsStateX on BuildContext {
  ImportSpotifyPlaylistsCubit get importSpotifyPlaylistsCubit => read<ImportSpotifyPlaylistsCubit>();
}

@injectable
class ImportSpotifyPlaylistsCubit extends Cubit<ImportSpotifyPlaylistsState> {
  ImportSpotifyPlaylistsCubit(
    this._spotifyRemoteRepository,
    this._spotifyAccessTokenProvider,
    this._eventBus,
  ) : super(ImportSpotifyPlaylistsState.initial());

  final SpotifyRemoteRepository _spotifyRemoteRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;
  final EventBus _eventBus;

  Future<void> onImportSpotifyPlaylists() async {
    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.executing()));

    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      emit(state.copyWith(importSpotifyPlaylistsState: ActionState.failed(NetworkCallError.unknown)));

      Logger.root.warning('Spotify access token is null, cannot import playlists');
      return;
    }

    final res = await _spotifyRemoteRepository.importSpotifyUserPlaylists(
      spotifyAccessToken: spotifyAccessToken,
    );

    emit(state.copyWith(importSpotifyPlaylistsState: ActionState.fromEither(res)));

    res.ifRight((r) => _eventBus.fire(EventSpotifyPlaylistsImported()));
  }
}
