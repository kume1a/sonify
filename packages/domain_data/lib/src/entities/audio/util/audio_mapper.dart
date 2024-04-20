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
    );
  }

  Audio entityToModel(AudioEntity e) {
    return Audio(
      id: e.remoteId,
      localId: e.id,
      title: e.title ?? '',
      author: e.author ?? '',
      durationMs: e.durationMs ?? 0,
      sizeBytes: e.sizeBytes ?? 0,
      thumbnailPath: e.thumbnailPath,
      youtubeVideoId: e.youtubeVideoId,
      path: e.path ?? '',
      localPath: e.localPath,
      createdAt: tryMapDateMillis(e.createdAtMillis),
      spotifyId: e.spotifyId,
      thumbnailUrl: e.thumbnailUrl,
      localThumbnailPath: e.localThumbnailPath,
    );
  }

  AudioEntity modelToEntity(Audio m) {
    final e = AudioEntity();

    e.remoteId = m.id;
    e.createdAtMillis = m.createdAt?.millisecondsSinceEpoch;
    e.title = m.title;
    e.durationMs = m.durationMs;
    e.path = m.path;
    e.author = m.author;
    e.sizeBytes = m.sizeBytes;
    e.youtubeVideoId = m.youtubeVideoId;
    e.spotifyId = m.spotifyId;
    e.thumbnailPath = m.thumbnailPath;
    e.thumbnailUrl = m.thumbnailUrl;
    e.localPath = m.localPath;
    e.localThumbnailPath = m.localThumbnailPath;

    return e;
  }
}
