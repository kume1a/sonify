import 'package:common_models/common_models.dart';

import '../model/spotify_refresh_token_payload.dart';
import '../model/spotify_token_payload.dart';

abstract interface class SpotifyAuthRemoteRepository {
  Future<Either<ActionFailure, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  });

  Future<Either<ActionFailure, SpotifyRefreshTokenPayload>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  });
}
