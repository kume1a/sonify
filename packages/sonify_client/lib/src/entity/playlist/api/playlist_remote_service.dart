import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteService {
  Future<Either<ActionFailure, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<FetchFailure, List<PlaylistDto>>> getAuthUserPlaylists();

  Future<Either<FetchFailure, PlaylistDto>> getPlaylistById({
    required String playlistId,
  });
}
