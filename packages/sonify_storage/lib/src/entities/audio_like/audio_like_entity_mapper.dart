import '../../db/tables.dart';
import 'audio_like_entity.dart';

class AudioLikeEntityMapper {
  AudioLikeEntity mapToEntity(Map<String, dynamic> map) {
    return AudioLikeEntity(
      id: map[AudioLike_.id] as String?,
      audioId: map[AudioLike_.audioId] as String?,
      userId: map[AudioLike_.userId] as String?,
    );
  }

  AudioLikeEntity? joinedMapToEntity(Map<String, dynamic> map) {
    final id = map[AudioLike_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return AudioLikeEntity(
      id: id,
      audioId: map[AudioLike_.joinedAudioId] as String?,
      userId: map[AudioLike_.joinedUserId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(AudioLikeEntity entity) {
    return {
      AudioLike_.id: entity.id,
      AudioLike_.userId: entity.userId,
      AudioLike_.audioId: entity.audioId,
    };
  }
}
