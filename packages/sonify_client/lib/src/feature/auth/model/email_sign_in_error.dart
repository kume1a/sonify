import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_sign_in_error.freezed.dart';

@freezed
class EmailSignInError with _$EmailSignInError {
  const factory EmailSignInError.network() = _network;

  const factory EmailSignInError.unknown() = _unknown;

  const factory EmailSignInError.invalidEmailOrPassword() = _invalidEmailOrPassword;

  const factory EmailSignInError.invalidAuthMethod() = _invalidAuthMethod;
}
