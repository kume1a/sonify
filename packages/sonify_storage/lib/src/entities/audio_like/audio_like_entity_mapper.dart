import '../../db/tables.dart';
import 'audio_like_entity.dart';

class AudioLikeEntityMapper {
  AudioLikeEntity mapToEntity(Map<String, dynamic> map) {
    return AudioLikeEntity(
      id: map[AudioLike_.id] as int?,
      bAudioId: map[AudioLike_.bAudioId] as String?,
      bUserId: map[AudioLike_.bUserId] as String?,
    );
  }

  AudioLikeEntity? joinedMapToEntity(Map<String, dynamic> map) {
    final id = map[AudioLike_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return AudioLikeEntity(
      id: id,
      bAudioId: map[AudioLike_.joinedBAudioId] as String?,
      bUserId: map[AudioLike_.joinedBUserId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(AudioLikeEntity entity) {
    return {
      AudioLike_.id: entity.id,
      AudioLike_.bUserId: entity.bUserId,
      AudioLike_.bAudioId: entity.bAudioId,
    };
  }
}
