import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';

typedef SpotifyPlaylistListState = SimpleDataState<List<Playlist>>;

extension SpotifyPlaylistListCubitX on BuildContext {
  SpotifyPlaylistListCubit get spotifyPlaylistListCubit => read<SpotifyPlaylistListCubit>();
}

@injectable
final class SpotifyPlaylistListCubit extends EntityLoaderCubit<List<Playlist>> {
  SpotifyPlaylistListCubit(
    this._playlistRepository,
  ) {
    loadEntityAndEmit();
  }

  final PlaylistRepository _playlistRepository;

  @override
  Future<List<Playlist>?> loadEntity() async {
    final res = await _playlistRepository.getAuthUserPlaylists();

    return res.rightOrNull;
  }

  void onPlaylistPressed(Playlist playlist) {}

  void onViewAllPressed() {}
}
