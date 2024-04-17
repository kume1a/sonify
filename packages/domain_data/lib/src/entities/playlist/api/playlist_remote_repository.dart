import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteRepository {
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<NetworkCallError, List<Playlist>>> getAuthUserPlaylists();

  Future<Either<NetworkCallError, Playlist>> getPlaylistById({
    required String playlistId,
  });
}
