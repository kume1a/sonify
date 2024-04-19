import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../model/user.dart';

class UserMapper {
  User dtoToModel(UserDto dto) {
    return User(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      name: dto.name,
      email: dto.email ?? '',
    );
  }
}
