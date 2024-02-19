import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_body.g.dart';

part 'google_sign_in_body.freezed.dart';

@freezed
class GoogleSignInBody with _$GoogleSignInBody {
  const factory GoogleSignInBody({
    required String token,
  }) = _GoogleSignInBody;

  factory GoogleSignInBody.fromJson(Map<String, dynamic> json) => _$GoogleSignInBodyFromJson(json);
}
