import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/email_sign_in_body.dart';
import '../model/email_sign_in_failure.dart';
import '../model/google_sign_in_body.dart';
import '../model/token_payload.dart';
import '../util/token_payload_mapper.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl with SafeHttpRequestWrap implements AuthRepository {
  AuthRepositoryImpl(
    this._apiClient,
    this._tokenPayloadMapper,
  );

  final ApiClient _apiClient;
  final TokenPayloadMapper _tokenPayloadMapper;

  @override
  Future<Either<ActionFailure, TokenPayload>> googleSignIn(String token) {
    return callCatchWithActionFailure(() async {
      final body = GoogleSignInBody(token: token);

      final res = await _apiClient.googleSignIn(body);

      return _tokenPayloadMapper.dtoToModel(res);
    });
  }

  @override
  Future<Either<EmailSignInFailure, TokenPayload>> emailSignIn({
    required String email,
    required String password,
  }) {
    return callCatch(
      call: () async {
        final body = EmailSignInBody(email: email, password: password);

        final res = await _apiClient.emailSignIn(body);

        return _tokenPayloadMapper.dtoToModel(res);
      },
      networkError: EmailSignInFailure.network(),
      unknownError: EmailSignInFailure.unknown(),
      onResponseError: (response) {
        final errorDto = ErrorResponseDto.fromJson(response?.data);

        return switch (errorDto.message) {
          ApiExceptionMessageCode.invalidEmailOrPassword => EmailSignInFailure.invalidEmailOrPassword(),
          ApiExceptionMessageCode.invalidAuthMethod => EmailSignInFailure.invalidAuthMethod(),
          _ => EmailSignInFailure.unknown(),
        };
      },
    );
  }
}
