import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../model/hidden_user_audio.dart';

class HiddenUserAudioMapper {
  HiddenUserAudio dtoToModel(HiddenUserAudioDto dto) {
    return HiddenUserAudio(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
    );
  }

  // UserAudio entityToModel(UserAudioEntity e) {
  //   return UserAudio(
  //     id: e.id,
  //     createdAt: tryMapDateMillis(e.createdAtMillis),
  //     userId: e.userId ?? kInvalidId,
  //     audioId: e.audioId ?? kInvalidId,
  //   );
  // }

  // UserAudioEntity modelToEntity(UserAudio m) {
  //   return UserAudioEntity(
  //     id: m.id,
  //     createdAtMillis: m.createdAt?.millisecondsSinceEpoch,
  //     userId: m.userId,
  //     audioId: m.audioId,
  //     audio: tryMap(m.audio, _audioMapper.modelToEntity),
  //   );
  // }
}
