import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/audio.dart';
import 'audio_like_mapper.dart';

class AudioMapper {
  AudioMapper(
    this._audioLikeMapper,
  );

  final AudioLikeMapper _audioLikeMapper;

  Audio dtoToModel(AudioDto dto) {
    return Audio(
      id: dto.id ?? kInvalidId,
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
      audioLike: tryMap(dto.audioLike, _audioLikeMapper.dtoToModel),
    );
  }

  Audio entityToModel(AudioEntity e) {
    return Audio(
      id: e.id,
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
      audioLike: tryMap(e.audioLike, _audioLikeMapper.entityToModel),
    );
  }

  AudioEntity modelToEntity(Audio m) {
    return AudioEntity(
      id: m.id,
      createdAtMillis: m.createdAt?.millisecondsSinceEpoch,
      title: m.title,
      durationMs: m.durationMs,
      path: m.path,
      localPath: m.localPath,
      author: m.author,
      sizeBytes: m.sizeBytes,
      youtubeVideoId: m.youtubeVideoId,
      spotifyId: m.spotifyId,
      thumbnailPath: m.thumbnailPath,
      thumbnailUrl: m.thumbnailUrl,
      localThumbnailPath: m.localThumbnailPath,
      audioLike: tryMap(m.audioLike, _audioLikeMapper.modelToEntity),
    );
  }
}
