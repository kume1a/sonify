import 'package:sonify_client/sonify_client.dart';

import '../model/spotify_refresh_token_payload.dart';

class SpotifyRefreshTokenPayloadMapper {
  SpotifyRefreshTokenPayload dtoToModel(SpotifyRefreshTokenPayloadDto dto) {
    return SpotifyRefreshTokenPayload(
      accessToken: dto.accessToken ?? '',
      tokenType: dto.tokenType ?? '',
      expiresIn: dto.expiresIn ?? 0,
      scope: dto.scope ?? '',
    );
  }
}
