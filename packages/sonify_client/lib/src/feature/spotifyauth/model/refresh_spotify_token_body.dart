import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_spotify_token_body.g.dart';

part 'refresh_spotify_token_body.freezed.dart';

@freezed
class RefreshSpotifyTokenBody with _$RefreshSpotifyTokenBody {
  const factory RefreshSpotifyTokenBody({
    required String spotifyRefreshToken,
  }) = _RefreshSpotifyTokenBody;

  factory RefreshSpotifyTokenBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshSpotifyTokenBodyFromJson(json);
}
