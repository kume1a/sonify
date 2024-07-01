import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_sign_in_body.g.dart';

part 'email_sign_in_body.freezed.dart';

@freezed
class EmailSignInBody with _$EmailSignInBody {
  const factory EmailSignInBody({
    required String email,
    required String password,
  }) = _EmailSignInBody;

  factory EmailSignInBody.fromJson(Map<String, dynamic> json) => _$EmailSignInBodyFromJson(json);
}