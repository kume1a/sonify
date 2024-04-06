import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_refresh_token_payload_dto.g.dart';

part 'spotify_refresh_token_payload_dto.freezed.dart';

@freezed
class SpotifyRefreshTokenPayloadDto with _$SpotifyRefreshTokenPayloadDto {
  const factory SpotifyRefreshTokenPayloadDto({
    String? accessToken,
    int? expiresIn,
    String? scope,
    String? tokenType,
  }) = _SpotifyRefreshTokenPayloadDto;

  factory SpotifyRefreshTokenPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$SpotifyRefreshTokenPayloadDtoFromJson(json);
}
