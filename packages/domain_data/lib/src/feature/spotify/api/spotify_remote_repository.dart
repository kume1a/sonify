import 'package:common_models/common_models.dart';

import '../../../entities/playlist/model/playlist.dart';
import '../model/spotify_refresh_token_payload.dart';
import '../model/spotify_search_result.dart';
import '../model/spotify_token_payload.dart';

abstract interface class SpotifyRemoteRepository {
  Future<Either<NetworkCallError, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  });

  Future<Either<NetworkCallError, SpotifyRefreshTokenPayload>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  });

  Future<Either<NetworkCallError, SpotifySearchResult>> search({
    required String spotifyAccessToken,
    required String keyword,
  });

  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<NetworkCallError, Playlist>> importSpotifyPlaylist({
    required String spotifyAccessToken,
    required String spotifyPlaylistId,
  });
}
