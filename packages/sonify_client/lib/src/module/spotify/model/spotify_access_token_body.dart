import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_access_token_body.g.dart';

part 'spotify_access_token_body.freezed.dart';

@freezed
class SpotifyAccessTokenBody with _$SpotifyAccessTokenBody {
  const factory SpotifyAccessTokenBody({
    required String spotifyAccessToken,
  }) = _SpotifyAccessTokenBody;

  factory SpotifyAccessTokenBody.fromJson(Map<String, dynamic> json) =>
      _$SpotifyAccessTokenBodyFromJson(json);
}
