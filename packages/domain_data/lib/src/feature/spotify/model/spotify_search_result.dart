import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_search_result.freezed.dart';

@freezed
class SpotifySearchResult with _$SpotifySearchResult {
  const factory SpotifySearchResult({
    required List<SpotifySearchResultPlaylist> playlists,
  }) = _SpotifySearchResult;
}

@freezed
class SpotifySearchResultPlaylist with _$SpotifySearchResultPlaylist {
  const factory SpotifySearchResultPlaylist({
    required String spotifyId,
    required String name,
    required String? imageUrl,
  }) = _SpotifySearchResultPlaylist;
}
