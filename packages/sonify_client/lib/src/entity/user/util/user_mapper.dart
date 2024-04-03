import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../model/user.dart';
import '../model/user_dto.dart';

class UserMapper {
  User dtoToModel(UserDto dto) {
    return User(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      name: dto.name ?? '',
      email: dto.email ?? '',
    );
  }
}
