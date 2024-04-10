import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_token_payload.freezed.dart';

@freezed
class SpotifyTokenPayload with _$SpotifyTokenPayload {
  const factory SpotifyTokenPayload({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) = _SpotifyTokenPayload;
}
