import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_refresh_token_payload.freezed.dart';

@freezed
class SpotifyRefreshTokenPayload with _$SpotifyRefreshTokenPayload {
  const factory SpotifyRefreshTokenPayload({
    required String accessToken,
    required int expiresIn,
    required String scope,
    required String tokenType,
  }) = _SpotifyRefreshTokenPayload;
}
