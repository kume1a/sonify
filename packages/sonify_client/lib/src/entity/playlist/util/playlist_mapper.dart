import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../model/playlist.dart';
import '../model/playlist_dto.dart';

class PlaylistMapper {
  Playlist dtoToModel(PlaylistDto dto) {
    return Playlist(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      name: dto.name ?? '',
      thumbnailPath: dto.thumbnailPath,
      thumbnailUrl: dto.thumbnailUrl,
      spotifyId: dto.spotifyId,
    );
  }
}
