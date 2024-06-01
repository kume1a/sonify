import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteRepository {
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<NetworkCallError, Playlist>> getById({
    required String playlistId,
  });
}
