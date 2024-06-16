import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorize_spotify_body.g.dart';

part 'authorize_spotify_body.freezed.dart';

@freezed
class AuthorizeSpotifyBody with _$AuthorizeSpotifyBody {
  const factory AuthorizeSpotifyBody({
    required String code,
  }) = _AuthorizeSpotifyBody;

  factory AuthorizeSpotifyBody.fromJson(Map<String, dynamic> json) => _$AuthorizeSpotifyBodyFromJson(json);
}
