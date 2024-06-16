import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_search_result_dto.g.dart';

part 'spotify_search_result_dto.freezed.dart';

@freezed
class SpotifySearchResultDto with _$SpotifySearchResultDto {
  const factory SpotifySearchResultDto({
    List<SpotifySearchResultPlaylistsDto>? playlists,
  }) = _SpotifySearchResultDto;

  factory SpotifySearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$SpotifySearchResultDtoFromJson(json);
}

@freezed
class SpotifySearchResultPlaylistsDto with _$SpotifySearchResultPlaylistsDto {
  const factory SpotifySearchResultPlaylistsDto({
    String? name,
    String? imageUrl,
    String? spotifyId,
  }) = _SpotifySearchResultPlaylistsDto;

  factory SpotifySearchResultPlaylistsDto.fromJson(Map<String, dynamic> json) =>
      _$SpotifySearchResultPlaylistsDtoFromJson(json);
}
