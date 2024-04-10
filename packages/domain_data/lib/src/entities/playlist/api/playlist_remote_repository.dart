import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteRepository {
  Future<Either<ActionFailure, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<FetchFailure, List<Playlist>>> getAuthUserPlaylists();

  Future<Either<FetchFailure, Playlist>> getPlaylistById({
    required String playlistId,
  });
}
