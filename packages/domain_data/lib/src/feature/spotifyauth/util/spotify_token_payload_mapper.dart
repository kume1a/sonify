import 'package:sonify_client/sonify_client.dart';

import '../model/spotify_token_payload.dart';

class SpotifyTokenPayloadMapper {
  SpotifyTokenPayload dtoToModel(SpotifyTokenPayloadDto dto) {
    return SpotifyTokenPayload(
      accessToken: dto.accessToken ?? '',
      refreshToken: dto.refreshToken ?? '',
      expiresIn: dto.expiresIn ?? -1,
    );
  }
}
