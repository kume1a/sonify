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

  UserAudio fromDto(UserAudioDto dto) {
    return UserAudio(
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
      audio: tryMap(dto.audio, _audioMapper.fromDto),
    );
  }

  UserAudio fromEntity(UserAudioEntity e) {
    return UserAudio(
      localId: e.id,
      createdAt: tryMapDateMillis(e.createdAtMillis),
      userId: e.bUserId ?? kInvalidId,
      audioId: e.bAudioId ?? kInvalidId,
      audio: tryMap(e.audio.value, _audioMapper.fromEntity),
    );
  }
}
