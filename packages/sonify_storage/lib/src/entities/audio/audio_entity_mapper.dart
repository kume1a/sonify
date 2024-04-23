import '../../db/tables.dart';
import 'audio_entity.dart';

class AudioEntityMapper {
  AudioEntity mapToEntity(Map<String, dynamic> m) {
    return AudioEntity(
      id: m[AudioEntity_.id] as int?,
      bId: m[AudioEntity_.bId] as String?,
      bCreatedAtMillis: m[AudioEntity_.bCreatedAtMillis] as int?,
      title: m[AudioEntity_.title] as String?,
      durationMs: m[AudioEntity_.durationMs] as int?,
      bPath: m[AudioEntity_.bPath] as String?,
      localPath: m[AudioEntity_.localPath] as String?,
      author: m[AudioEntity_.author] as String?,
      sizeBytes: m[AudioEntity_.sizeBytes] as int?,
      youtubeVideoId: m[AudioEntity_.youtubeVideoId] as String?,
      spotifyId: m[AudioEntity_.spotifyId] as String?,
      bThumbnailPath: m[AudioEntity_.bThumbnailPath] as String?,
      thumbnailUrl: m[AudioEntity_.thumbnailUrl] as String?,
      localThumbnailPath: m[AudioEntity_.localThumbnailPath] as String?,
    );
  }

  AudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[AudioEntity_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return AudioEntity(
      id: id,
      bId: m[AudioEntity_.joinedBId] as String?,
      bCreatedAtMillis: m[AudioEntity_.joinedBCreatedAtMillis] as int?,
      title: m[AudioEntity_.joinedTitle] as String?,
      durationMs: m[AudioEntity_.joinedDurationMs] as int?,
      bPath: m[AudioEntity_.joinedBPath] as String?,
      localPath: m[AudioEntity_.joinedLocalPath] as String?,
      author: m[AudioEntity_.joinedAuthor] as String?,
      sizeBytes: m[AudioEntity_.joinedSizeBytes] as int?,
      youtubeVideoId: m[AudioEntity_.joinedYoutubeVideoId] as String?,
      spotifyId: m[AudioEntity_.joinedSpotifyId] as String?,
      bThumbnailPath: m[AudioEntity_.joinedBThumbnailPath] as String?,
      thumbnailUrl: m[AudioEntity_.joinedThumbnailUrl] as String?,
      localThumbnailPath: m[AudioEntity_.joinedLocalThumbnailPath] as String?,
    );
  }

  Map<String, dynamic> entityToMap(AudioEntity e) {
    return {
      AudioEntity_.id: e.id,
      AudioEntity_.bId: e.bId,
      AudioEntity_.bCreatedAtMillis: e.bCreatedAtMillis,
      AudioEntity_.title: e.title,
      AudioEntity_.durationMs: e.durationMs,
      AudioEntity_.bPath: e.bPath,
      AudioEntity_.localPath: e.localPath,
      AudioEntity_.author: e.author,
      AudioEntity_.sizeBytes: e.sizeBytes,
      AudioEntity_.youtubeVideoId: e.youtubeVideoId,
      AudioEntity_.spotifyId: e.spotifyId,
      AudioEntity_.bThumbnailPath: e.bThumbnailPath,
      AudioEntity_.thumbnailUrl: e.thumbnailUrl,
      AudioEntity_.localThumbnailPath: e.localThumbnailPath,
    };
  }
}
