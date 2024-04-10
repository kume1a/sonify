import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/email_sign_in_body.dart';
import '../model/email_sign_in_failure.dart';
import '../model/google_sign_in_body.dart';
import '../model/token_payload_dto.dart';
import 'auth_remote_service.dart';

class AuthRemoteServiceImpl with SafeHttpRequestWrap implements AuthRemoteService {
  AuthRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<ActionFailure, TokenPayloadDto>> googleSignIn({
    required String token,
  }) {
    return callCatchWithActionFailure(() {
      final body = GoogleSignInBody(token: token);

      return _apiClient.googleSignIn(body);
    });
  }

  @override
  Future<Either<EmailSignInFailure, TokenPayloadDto>> emailSignIn({
    required String email,
    required String password,
  }) {
    return callCatch(
      call: () {
        final body = EmailSignInBody(email: email, password: password);

        return _apiClient.emailSignIn(body);
      },
      networkError: const EmailSignInFailure.network(),
      unknownError: const EmailSignInFailure.unknown(),
      onResponseError: (response) {
        final errorDto = ErrorResponseDto.fromJson(response?.data);

        return switch (errorDto.message) {
          ApiExceptionMessageCode.invalidEmailOrPassword => const EmailSignInFailure.invalidEmailOrPassword(),
          ApiExceptionMessageCode.invalidAuthMethod => const EmailSignInFailure.invalidAuthMethod(),
          _ => const EmailSignInFailure.unknown(),
        };
      },
    );
  }
}
