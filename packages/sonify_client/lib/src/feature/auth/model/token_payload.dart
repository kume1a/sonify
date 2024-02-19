import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_payload.freezed.dart';

@freezed
class TokenPayload with _$TokenPayload {
  const factory TokenPayload({
    required String accessToken,
  }) = _TokenPayload;
}
