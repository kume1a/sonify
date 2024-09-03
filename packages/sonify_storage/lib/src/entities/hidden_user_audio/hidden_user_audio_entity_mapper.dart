import '../../db/tables.dart';
import 'hidden_user_audio_entity.dart';

class HiddenUserAudioEntityMapper {
  HiddenUserAudioEntity mapToEntity(Map<String, dynamic> m) {
    return HiddenUserAudioEntity(
      id: m[HiddenUserAudio_.id] as String?,
      createdAtMillis: m[HiddenUserAudio_.createdAtMillis] as int?,
      userId: m[HiddenUserAudio_.userId] as String?,
      audioId: m[HiddenUserAudio_.audioId] as String?,
    );
  }

  HiddenUserAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[HiddenUserAudio_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return HiddenUserAudioEntity(
      id: id,
      createdAtMillis: m[HiddenUserAudio_.joinedCreatedAtMillis] as int?,
      userId: m[HiddenUserAudio_.joinedUserId] as String?,
      audioId: m[HiddenUserAudio_.joinedAudioId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(HiddenUserAudioEntity e) {
    return {
      HiddenUserAudio_.id: e.id,
      HiddenUserAudio_.createdAtMillis: e.createdAtMillis,
      HiddenUserAudio_.userId: e.userId,
      HiddenUserAudio_.audioId: e.audioId,
    };
  }
}
