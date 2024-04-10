import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/token_payload.dart';
import '../util/token_payload_mapper.dart';
import 'auth_remote_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  AuthRemoteRepositoryImpl(
    this._authRemoteService,
    this._tokenPayloadMapper,
  );

  final AuthRemoteService _authRemoteService;
  final TokenPayloadMapper _tokenPayloadMapper;

  @override
  Future<Either<ActionFailure, TokenPayload>> googleSignIn({
    required String token,
  }) async {
    final res = await _authRemoteService.googleSignIn(token: token);

    return res.map(_tokenPayloadMapper.dtoToModel);
  }

  @override
  Future<Either<EmailSignInFailure, TokenPayload>> emailSignIn({
    required String email,
    required String password,
  }) async {
    final res = await _authRemoteService.emailSignIn(
      email: email,
      password: password,
    );

    return res.map(_tokenPayloadMapper.dtoToModel);
  }
}
