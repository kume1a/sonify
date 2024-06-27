import 'package:common_models/common_models.dart';

import '../model/spotify_refresh_token_payload_dto.dart';
import '../model/spotify_search_result_dto.dart';
import '../model/spotify_token_payload_dto.dart';

abstract interface class SpotifyRemoteService {
  Future<Either<NetworkCallError, SpotifyTokenPayloadDto>> authorizeSpotify({
    required String code,
  });

  Future<Either<NetworkCallError, SpotifyRefreshTokenPayloadDto>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  });

  Future<Either<NetworkCallError, SpotifySearchResultDto>> search({
    required String spotifyAccessToken,
    required String keyword,
  });

  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  });

  Future<Either<NetworkCallError, Unit>> importSpotifyPlaylist({
    required String spotifyAccessToken,
    required String spotifyPlaylistId,
  });
}
