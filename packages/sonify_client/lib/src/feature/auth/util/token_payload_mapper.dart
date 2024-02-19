import '../model/token_payload.dart';
import '../model/token_payload_dto.dart';

class TokenPayloadMapper {
  TokenPayload dtoToModel(TokenPayloadDto dto) {
    return TokenPayload(accessToken: dto.accessToken!);
  }
}
