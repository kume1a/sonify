import 'package:common_models/common_models.dart';

import '../model/user.dart';

abstract interface class UserRemoteRepository {
  Future<Either<ActionFailure, User>> updateUser({
    String? name,
  });

  Future<Either<FetchFailure, User>> getAuthUser();
}
