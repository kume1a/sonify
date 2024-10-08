import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../../audiolike/util/audio_like_mapper.dart';
import '../../hidden_user_audio/util/hidden_user_audio_mapper.dart';
import '../model/audio.dart';

class AudioMapper {
  AudioMapper(
    this._audioLikeMapper,
    this._hiddenUserAudioMapper,
  );

  final AudioLikeMapper _audioLikeMapper;
  final HiddenUserAudioMapper _hiddenUserAudioMapper;

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
      hiddenUserAudio: tryMap(dto.hiddenUserAudio, _hiddenUserAudioMapper.dtoToModel),
    );
  }

  Audio entityToModel(AudioEntity e) {
    return Audio(
      id: e.id ?? kInvalidId,
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
      hiddenUserAudio: tryMap(e.hiddenUserAudio, _hiddenUserAudioMapper.entityToModel),
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
      hiddenUserAudio: tryMap(m.hiddenUserAudio, _hiddenUserAudioMapper.modelToEntity),
    );
  }
}
