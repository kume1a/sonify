import '../model/spotify_token_payload.dart';
import '../model/spotify_token_payload_dto.dart';

class SpotifyTokenPayloadMapper {
  SpotifyTokenPayload dtoToModel(SpotifyTokenPayloadDto dto) {
    return SpotifyTokenPayload(
      accessToken: dto.accessToken ?? '',
      refreshToken: dto.refreshToken ?? '',
      expiresIn: dto.expiresIn ?? -1,
    );
  }
}
