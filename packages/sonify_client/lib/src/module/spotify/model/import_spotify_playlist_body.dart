import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_spotify_playlist_body.g.dart';

part 'import_spotify_playlist_body.freezed.dart';

@freezed
class ImportSpotifyPlaylistBody with _$ImportSpotifyPlaylistBody {
  const factory ImportSpotifyPlaylistBody({
    required String spotifyAccessToken,
    required String spotifyPlaylistId,
  }) = _ImportSpotifyPlaylistBody;

  factory ImportSpotifyPlaylistBody.fromJson(Map<String, dynamic> json) =>
      _$ImportSpotifyPlaylistBodyFromJson(json);
}
