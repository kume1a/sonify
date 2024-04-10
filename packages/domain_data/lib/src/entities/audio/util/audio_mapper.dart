import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/audio.dart';

class AudioMapper {
  Audio fromDto(AudioDto dto) {
    return Audio(
      id: dto.id ?? kInvalidId,
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      title: dto.title ?? '',
      durationMs: dto.durationMs ?? 0,
      path: dto.path ?? '',
      author: dto.author ?? '',
      sizeBytes: dto.sizeBytes ?? 0,
      thumbnailPath: dto.thumbnailPath,
      youtubeVideoId: dto.youtubeVideoId,
      thumbnailUrl: dto.thumbnailUrl,
      spotifyId: dto.spotifyId,
    );
  }

  Audio fromEntity(AudioEntity e) {
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
      createdAt: tryMapDateMillis(e.createdAtMillis),
      spotifyId: e.spotifyId,
      thumbnailUrl: e.thumbnailUrl,
    );
  }
}
