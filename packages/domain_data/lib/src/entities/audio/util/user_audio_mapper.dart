import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/user_audio.dart';
import 'audio_mapper.dart';

class UserAudioMapper {
  UserAudioMapper(
    this._audioMapper,
  );

  final AudioMapper _audioMapper;

  UserAudio dtoToModel(UserAudioDto dto) {
    return UserAudio(
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
      localAudioId: null,
      audio: tryMap(dto.audio, _audioMapper.dtoToModel),
    );
  }

  UserAudio entityToModel(UserAudioEntity e) {
    return UserAudio(
      localId: e.id,
      createdAt: tryMapDateMillis(e.bCreatedAtMillis),
      userId: e.bUserId ?? kInvalidId,
      audioId: e.bAudioId ?? kInvalidId,
      localAudioId: e.audioId,
      audio: tryMap(e.audio, _audioMapper.entityToModel),
    );
  }

  UserAudioEntity modelToEntity(UserAudio m) {
    return UserAudioEntity(
      id: m.localId,
      bCreatedAtMillis: m.createdAt?.millisecondsSinceEpoch,
      bUserId: m.userId,
      bAudioId: m.audioId,
      audioId: m.localAudioId,
      audio: tryMap(m.audio, _audioMapper.modelToEntity),
    );
  }
}
