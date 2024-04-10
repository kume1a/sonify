import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../entities/user/util/user_mapper.dart';
import '../model/token_payload.dart';

class TokenPayloadMapper {
  TokenPayloadMapper(
    this._userMapper,
  );

  final UserMapper _userMapper;

  TokenPayload dtoToModel(TokenPayloadDto dto) {
    return TokenPayload(
      accessToken: dto.accessToken!,
      user: tryMap(dto.user, _userMapper.dtoToModel),
    );
  }
}
