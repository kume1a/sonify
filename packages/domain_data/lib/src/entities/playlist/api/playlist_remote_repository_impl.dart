import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';
import '../util/playlist_mapper.dart';
import 'playlist_remote_repository.dart';

class PlaylistRemoteRepositoryImpl implements PlaylistRemoteRepository {
  PlaylistRemoteRepositoryImpl(
    this._playlistRemoteService,
    this._playlistMapper,
  );

  final PlaylistRemoteService _playlistRemoteService;
  final PlaylistMapper _playlistMapper;

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  }) {
    return _playlistRemoteService.importSpotifyUserPlaylists(
      spotifyAccessToken: spotifyAccessToken,
    );
  }

  @override
  Future<Either<NetworkCallError, List<Playlist>>> getAuthUserPlaylists({
    List<String>? ids,
  }) async {
    final res = await _playlistRemoteService.getAuthUserPlaylists(ids: ids);

    return res.map((r) => r.map(_playlistMapper.dtoToModel).toList());
  }

  @override
  Future<Either<NetworkCallError, Playlist>> getPlaylistById({
    required String playlistId,
  }) async {
    final res = await _playlistRemoteService.getPlaylistById(playlistId: playlistId);

    return res.map(_playlistMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAuthUserPlaylistIds() {
    return _playlistRemoteService.getAuthUserPlaylistIds();
  }
}
