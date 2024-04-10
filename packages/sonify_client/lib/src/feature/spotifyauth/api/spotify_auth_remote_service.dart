import 'package:common_models/common_models.dart';

import '../model/spotify_refresh_token_payload_dto.dart';
import '../model/spotify_token_payload_dto.dart';

abstract interface class SpotifyAuthRemoteService {
  Future<Either<ActionFailure, SpotifyTokenPayloadDto>> authorizeSpotify({
    required String code,
  });

  Future<Either<ActionFailure, SpotifyRefreshTokenPayloadDto>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  });
}
