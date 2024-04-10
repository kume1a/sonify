import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/token_payload.dart';

abstract interface class AuthRemoteRepository {
  Future<Either<ActionFailure, TokenPayload>> googleSignIn({
    required String token,
  });

  Future<Either<EmailSignInFailure, TokenPayload>> emailSignIn({
    required String email,
    required String password,
  });
}
