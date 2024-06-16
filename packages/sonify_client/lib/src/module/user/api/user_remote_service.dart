import 'package:common_models/common_models.dart';

import '../model/user_dto.dart';

abstract interface class UserRemoteService {
  Future<Either<NetworkCallError, UserDto>> updateUser({
    String? name,
  });

  Future<Either<NetworkCallError, UserDto>> getAuthUser();
}
