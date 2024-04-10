import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/playlist_page.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';

typedef SpotifyPlaylistListState = SimpleDataState<List<Playlist>>;

extension SpotifyPlaylistListCubitX on BuildContext {
  SpotifyPlaylistListCubit get spotifyPlaylistListCubit => read<SpotifyPlaylistListCubit>();
}

@injectable
final class SpotifyPlaylistListCubit extends EntityLoaderCubit<List<Playlist>> {
  SpotifyPlaylistListCubit(
    this._playlistRemoteRepository,
    this._pageNavigator,
  ) {
    loadEntityAndEmit();
  }

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PageNavigator _pageNavigator;

  @override
  Future<List<Playlist>?> loadEntity() async {
    final res = await _playlistRemoteRepository.getAuthUserPlaylists();

    return res.rightOrNull;
  }

  void onPlaylistPressed(Playlist playlist) {
    final args = PlaylistPageArgs(playlistId: playlist.id);

    _pageNavigator.toPlaylist(args);
  }

  void onViewAllPressed() {}
}
