import 'package:common_models/common_models.dart';

import '../model/token_payload.dart';

abstract interface class AuthRepository {
  Future<Either<ActionFailure, TokenPayload>> googleSignIn(String token);

  Future<Either<ActionFailure, TokenPayload>> emailSignIn({
    required String email,
    required String password,
  });
}
