import 'package:common_models/common_models.dart';

import '../model/email_sign_in_failure.dart';
import '../model/token_payload_dto.dart';

abstract interface class AuthRemoteService {
  Future<Either<ActionFailure, TokenPayloadDto>> googleSignIn({
    required String token,
  });

  Future<Either<EmailSignInFailure, TokenPayloadDto>> emailSignIn({
    required String email,
    required String password,
  });
}
