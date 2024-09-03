import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

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

  HiddenUserAudio entityToModel(HiddenUserAudioEntity e) {
    return HiddenUserAudio(
      id: e.id ?? kInvalidId,
      createdAt: tryMapDateMillis(e.createdAtMillis),
      userId: e.userId ?? kInvalidId,
      audioId: e.audioId ?? kInvalidId,
    );
  }

  HiddenUserAudioEntity modelToEntity(HiddenUserAudio m) {
    return HiddenUserAudioEntity(
      id: m.id,
      createdAtMillis: m.createdAt?.millisecondsSinceEpoch,
      userId: m.userId,
      audioId: m.audioId,
    );
  }
}
