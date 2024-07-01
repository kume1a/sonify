import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../model/spotify_search_result.dart';

class SpotifySearchResultMapper {
  SpotifySearchResult dtoToModel(SpotifySearchResultDto dto) {
    return SpotifySearchResult(
      playlists: mapListOrEmpty(dto.playlists, _dtoToModelPlaylist),
    );
  }

  SpotifySearchResultPlaylist _dtoToModelPlaylist(SpotifySearchResultPlaylistsDto dto) {
    return SpotifySearchResultPlaylist(
      spotifyId: dto.spotifyId ?? kInvalidId,
      name: dto.name ?? '',
      imageUrl: dto.imageUrl,
      playlistId: dto.playlistId,
    );
  }
}
