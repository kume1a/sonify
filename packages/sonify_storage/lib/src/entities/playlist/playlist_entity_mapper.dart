import '../../db/tables.dart';
import 'playlist_entity.dart';

class PlaylistEntityMapper {
  PlaylistEntity mapToEntity(Map<String, dynamic> m) {
    return PlaylistEntity(
      id: m[Playlist_.id] as String?,
      createdAtMillis: m[Playlist_.createdAtMillis] as int?,
      name: m[Playlist_.name] as String?,
      spotifyId: m[Playlist_.spotifyId] as String?,
      thumbnailPath: m[Playlist_.thumbnailPath] as String?,
      thumbnailUrl: m[Playlist_.thumbnailUrl] as String?,
      audioImportStatus: m[Playlist_.audioImportStatus] as String?,
      audioCount: m[Playlist_.audioCount] as int?,
      totalAudioCount: m[Playlist_.totalAudioCount] as int?,
    );
  }

  PlaylistEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[Playlist_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return PlaylistEntity(
      id: id,
      createdAtMillis: m[Playlist_.joinedCreatedAtMillis] as int?,
      spotifyId: m[Playlist_.joinedSpotifyId] as String?,
      thumbnailPath: m[Playlist_.joinedThumbnailPath] as String?,
      thumbnailUrl: m[Playlist_.joinedThumbnailUrl] as String?,
      name: m[Playlist_.joinedName] as String?,
      audioCount: m[Playlist_.joinedAudioCount] as int?,
      totalAudioCount: m[Playlist_.joinedTotalAudioCount] as int?,
      audioImportStatus: m[Playlist_.joinedAudioImportStatus] as String?,
    );
  }

  Map<String, dynamic> entityToMap(PlaylistEntity e) {
    return {
      Playlist_.id: e.id,
      Playlist_.createdAtMillis: e.createdAtMillis,
      Playlist_.spotifyId: e.spotifyId,
      Playlist_.thumbnailPath: e.thumbnailPath,
      Playlist_.thumbnailUrl: e.thumbnailUrl,
      Playlist_.name: e.name,
      Playlist_.audioCount: e.audioCount,
      Playlist_.totalAudioCount: e.totalAudioCount,
      Playlist_.audioImportStatus: e.audioImportStatus,
    };
  }
}
