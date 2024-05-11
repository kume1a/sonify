import '../../db/tables.dart';
import 'playlist_entity.dart';

class PlaylistEntityMapper {
  PlaylistEntity mapToEntity(Map<String, dynamic> m) {
    return PlaylistEntity(
      id: m[Playlist_.id] as int?,
      bId: m[Playlist_.bId] as String?,
      bCreatedAtMillis: m[Playlist_.bCreatedAtMillis] as int?,
      name: m[Playlist_.name] as String?,
      spotifyId: m[Playlist_.spotifyId] as String?,
      bThumbnailPath: m[Playlist_.bThumbnailPath] as String?,
      thumbnailUrl: m[Playlist_.thumbnailUrl] as String?,
    );
  }

  PlaylistEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[Playlist_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return PlaylistEntity(
      id: id,
      bId: m[Playlist_.joinedBId] as String?,
      bCreatedAtMillis: m[Playlist_.joinedBCreatedAtMillis] as int?,
      spotifyId: m[Playlist_.joinedSpotifyId] as String?,
      bThumbnailPath: m[Playlist_.joinedBThumbnailPath] as String?,
      thumbnailUrl: m[Playlist_.joinedThumbnailUrl] as String?,
      name: m[Playlist_.joinedName] as String?,
    );
  }

  Map<String, dynamic> entityToMap(PlaylistEntity e) {
    return {
      Playlist_.id: e.id,
      Playlist_.bId: e.bId,
      Playlist_.bCreatedAtMillis: e.bCreatedAtMillis,
      Playlist_.spotifyId: e.spotifyId,
      Playlist_.bThumbnailPath: e.bThumbnailPath,
      Playlist_.thumbnailUrl: e.thumbnailUrl,
      Playlist_.name: e.name,
    };
  }
}
