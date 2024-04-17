import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/email_sign_in_body.dart';
import '../model/email_sign_in_error.dart';
import '../model/google_sign_in_body.dart';
import '../model/token_payload_dto.dart';
import 'auth_remote_service.dart';

class AuthRemoteServiceImpl with SafeHttpRequestWrap implements AuthRemoteService {
  AuthRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, TokenPayloadDto>> googleSignIn({
    required String token,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = GoogleSignInBody(token: token);

      return _apiClient.googleSignIn(body);
    });
  }

  @override
  Future<Either<EmailSignInError, TokenPayloadDto>> emailSignIn({
    required String email,
    required String password,
  }) {
    return callCatch(
      call: () {
        final body = EmailSignInBody(email: email, password: password);

        return _apiClient.emailSignIn(body);
      },
      networkError: const EmailSignInError.network(),
      unknownError: const EmailSignInError.unknown(),
      onResponseError: (response) {
        final errorDto = ErrorResponseDto.fromJson(response?.data);

        return switch (errorDto.message) {
          ApiExceptionMessageCode.invalidEmailOrPassword => const EmailSignInError.invalidEmailOrPassword(),
          ApiExceptionMessageCode.invalidAuthMethod => const EmailSignInError.invalidAuthMethod(),
          _ => const EmailSignInError.unknown(),
        };
      },
    );
  }
}
