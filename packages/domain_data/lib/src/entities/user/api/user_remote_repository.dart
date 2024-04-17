import 'package:common_models/common_models.dart';

import '../model/user.dart';

abstract interface class UserRemoteRepository {
  Future<Either<NetworkCallError, User>> updateUser({
    String? name,
  });

  Future<Either<NetworkCallError, User>> getAuthUser();
}
