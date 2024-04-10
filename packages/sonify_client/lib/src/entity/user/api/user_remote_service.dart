import 'package:common_models/common_models.dart';

import '../model/user_dto.dart';

abstract interface class UserRemoteService {
  Future<Either<ActionFailure, UserDto>> updateUser({
    String? name,
  });

  Future<Either<FetchFailure, UserDto>> getAuthUser();
}
