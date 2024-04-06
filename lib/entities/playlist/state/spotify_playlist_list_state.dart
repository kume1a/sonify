import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/di/register_dependencies.dart';
import '../../../app/navigation/page_navigator.dart';
import '../../../features/spotifyauth/api/spotify_access_token_provider.dart';
import '../../../pages/playlist_page.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';

typedef SpotifyPlaylistListState = SimpleDataState<List<Playlist>>;

extension SpotifyPlaylistListCubitX on BuildContext {
  SpotifyPlaylistListCubit get spotifyPlaylistListCubit => read<SpotifyPlaylistListCubit>();
}

@injectable
final class SpotifyPlaylistListCubit extends EntityLoaderCubit<List<Playlist>> {
  SpotifyPlaylistListCubit(
    this._playlistRepository,
    this._pageNavigator,
  ) {
    loadEntityAndEmit();
  }

  final PlaylistRepository _playlistRepository;
  final PageNavigator _pageNavigator;

  @override
  Future<List<Playlist>?> loadEntity() async {
    getIt<SpotifyAccessTokenProvider>().get();

    final res = await _playlistRepository.getAuthUserPlaylists();

    return res.rightOrNull;
  }

  void onPlaylistPressed(Playlist playlist) {
    final args = PlaylistPageArgs(playlistId: playlist.id);

    _pageNavigator.toPlaylist(args);
  }

  void onViewAllPressed() {}
}
