import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_token_payload_dto.g.dart';

part 'spotify_token_payload_dto.freezed.dart';

@freezed
class SpotifyTokenPayloadDto with _$SpotifyTokenPayloadDto {
  const factory SpotifyTokenPayloadDto({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    String? scope,
    String? tokenType,
  }) = _SpotifyTokenPayloadDto;

  factory SpotifyTokenPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTokenPayloadDtoFromJson(json);
}
