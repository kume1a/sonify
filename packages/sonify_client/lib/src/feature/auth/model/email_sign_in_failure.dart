import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_sign_in_failure.freezed.dart';

@freezed
class EmailSignInFailure with _$EmailSignInFailure {
  const factory EmailSignInFailure.network() = _network;

  const factory EmailSignInFailure.unknown() = _unknown;

  const factory EmailSignInFailure.invalidEmailOrPassword() = _invalidEmailOrPassword;

  const factory EmailSignInFailure.invalidAuthMethod() = _invalidAuthMethod;
}
