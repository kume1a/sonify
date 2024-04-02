import 'package:common_models/common_models.dart';

import '../model/spotify_token_payload.dart';

abstract interface class SpotifyAuthRepository {
  Future<Either<ActionFailure, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  });
}
