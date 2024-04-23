import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/audio.dart';

class AudioMapper {
  Audio dtoToModel(AudioDto dto) {
    return Audio(
      id: dto.id ?? kInvalidId,
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      title: dto.title ?? '',
      durationMs: dto.durationMs ?? 0,
      path: dto.path ?? '',
      localPath: null,
      author: dto.author ?? '',
      sizeBytes: dto.sizeBytes ?? 0,
      youtubeVideoId: dto.youtubeVideoId,
      spotifyId: dto.spotifyId,
      thumbnailUrl: dto.thumbnailUrl,
      thumbnailPath: dto.thumbnailPath,
      localThumbnailPath: null,
      isLiked: dto.isLiked ?? false,
    );
  }

  Audio entityToModel(AudioEntity e) {
    return Audio(
      id: e.bId,
      localId: e.id,
      title: e.title ?? '',
      author: e.author ?? '',
      durationMs: e.durationMs ?? 0,
      sizeBytes: e.sizeBytes ?? 0,
      thumbnailPath: e.bThumbnailPath,
      youtubeVideoId: e.youtubeVideoId,
      path: e.bPath ?? '',
      localPath: e.localPath,
      createdAt: tryMapDateMillis(e.bCreatedAtMillis),
      spotifyId: e.spotifyId,
      thumbnailUrl: e.thumbnailUrl,
      localThumbnailPath: e.localThumbnailPath,
      isLiked: e.isLiked ?? false,
    );
  }

  AudioEntity modelToEntity(Audio m) {
    return AudioEntity(
      id: m.localId,
      bId: m.id,
      bCreatedAtMillis: m.createdAt?.millisecondsSinceEpoch,
      title: m.title,
      durationMs: m.durationMs,
      bPath: m.path,
      localPath: m.localPath,
      author: m.author,
      sizeBytes: m.sizeBytes,
      youtubeVideoId: m.youtubeVideoId,
      spotifyId: m.spotifyId,
      bThumbnailPath: m.thumbnailPath,
      thumbnailUrl: m.thumbnailUrl,
      localThumbnailPath: m.localThumbnailPath,
      isLiked: m.isLiked,
    );
  }
}
