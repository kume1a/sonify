import 'package:common_models/common_models.dart';

abstract interface class PlaylistRepository {
  Future<Either<FetchFailure, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });
}
