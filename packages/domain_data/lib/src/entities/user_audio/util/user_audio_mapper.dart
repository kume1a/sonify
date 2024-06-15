import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../../audio/model/user_audio.dart';
import '../../audio/util/audio_mapper.dart';

class UserAudioMapper {
  UserAudioMapper(
    this._audioMapper,
  );

  final AudioMapper _audioMapper;

  UserAudio dtoToModel(UserAudioDto dto) {
    return UserAudio(
      id: dto.id,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
      audio: tryMap(dto.audio, _audioMapper.dtoToModel),
    );
  }

  UserAudio entityToModel(UserAudioEntity e) {
    return UserAudio(
      id: e.id,
      createdAt: tryMapDateMillis(e.createdAtMillis),
      userId: e.userId ?? kInvalidId,
      audioId: e.audioId ?? kInvalidId,
      audio: tryMap(e.audio, _audioMapper.entityToModel),
    );
  }

  UserAudioEntity modelToEntity(UserAudio m) {
    return UserAudioEntity(
      id: m.id,
      createdAtMillis: m.createdAt?.millisecondsSinceEpoch,
      userId: m.userId,
      audioId: m.audioId,
      audio: tryMap(m.audio, _audioMapper.modelToEntity),
    );
  }
}
