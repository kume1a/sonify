import '../../db/tables.dart';
import 'audio_like_entity.dart';

class AudioLikeEntityMapper {
  AudioLikeEntity mapToEntity(Map<String, dynamic> map) {
    return AudioLikeEntity(
      id: map[AudioLikeEntity_.id] as int?,
      bAudioId: map[AudioLikeEntity_.bAudioId] as String?,
      bUserId: map[AudioLikeEntity_.bUserId] as String?,
    );
  }

  AudioLikeEntity? joinedMapToEntity(Map<String, dynamic> map) {
    final id = map[AudioLikeEntity_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return AudioLikeEntity(
      id: id,
      bAudioId: map[AudioLikeEntity_.joinedBAudioId] as String?,
      bUserId: map[AudioLikeEntity_.joinedBUserId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(AudioLikeEntity entity) {
    return {
      AudioLikeEntity_.id: entity.id,
      AudioLikeEntity_.bUserId: entity.bUserId,
      AudioLikeEntity_.bAudioId: entity.bAudioId,
    };
  }
}
