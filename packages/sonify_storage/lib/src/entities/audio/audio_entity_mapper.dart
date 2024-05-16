import '../../db/tables.dart';
import '../audio_like/audio_like_entity_mapper.dart';
import 'audio_entity.dart';

class AudioEntityMapper {
  AudioEntityMapper(
    this._audioLikeEntityMapper,
  );

  final AudioLikeEntityMapper _audioLikeEntityMapper;

  AudioEntity mapToEntity(Map<String, dynamic> m) {
    return AudioEntity(
      id: m[Audio_.id] as String?,
      createdAtMillis: m[Audio_.createdAtMillis] as int?,
      title: m[Audio_.title] as String?,
      durationMs: m[Audio_.durationMs] as int?,
      path: m[Audio_.path] as String?,
      localPath: m[Audio_.localPath] as String?,
      author: m[Audio_.author] as String?,
      sizeBytes: m[Audio_.sizeBytes] as int?,
      youtubeVideoId: m[Audio_.youtubeVideoId] as String?,
      spotifyId: m[Audio_.spotifyId] as String?,
      thumbnailPath: m[Audio_.thumbnailPath] as String?,
      thumbnailUrl: m[Audio_.thumbnailUrl] as String?,
      localThumbnailPath: m[Audio_.localThumbnailPath] as String?,
      audioLike: _audioLikeEntityMapper.joinedMapToEntity(m),
    );
  }

  AudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[Audio_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return AudioEntity(
      id: id,
      createdAtMillis: m[Audio_.joinedCreatedAtMillis] as int?,
      title: m[Audio_.joinedTitle] as String?,
      durationMs: m[Audio_.joinedDurationMs] as int?,
      path: m[Audio_.joinedPath] as String?,
      localPath: m[Audio_.joinedLocalPath] as String?,
      author: m[Audio_.joinedAuthor] as String?,
      sizeBytes: m[Audio_.joinedSizeBytes] as int?,
      youtubeVideoId: m[Audio_.joinedYoutubeVideoId] as String?,
      spotifyId: m[Audio_.joinedSpotifyId] as String?,
      thumbnailPath: m[Audio_.joinedThumbnailPath] as String?,
      thumbnailUrl: m[Audio_.joinedThumbnailUrl] as String?,
      localThumbnailPath: m[Audio_.joinedLocalThumbnailPath] as String?,
      audioLike: _audioLikeEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(AudioEntity e) {
    return {
      Audio_.id: e.id,
      Audio_.createdAtMillis: e.createdAtMillis,
      Audio_.title: e.title,
      Audio_.durationMs: e.durationMs,
      Audio_.path: e.path,
      Audio_.localPath: e.localPath,
      Audio_.author: e.author,
      Audio_.sizeBytes: e.sizeBytes,
      Audio_.youtubeVideoId: e.youtubeVideoId,
      Audio_.spotifyId: e.spotifyId,
      Audio_.thumbnailPath: e.thumbnailPath,
      Audio_.thumbnailUrl: e.thumbnailUrl,
      Audio_.localThumbnailPath: e.localThumbnailPath,
    };
  }
}
