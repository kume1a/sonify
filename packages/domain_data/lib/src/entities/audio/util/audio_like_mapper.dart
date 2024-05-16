import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio_like.dart';

class AudioLikeMapper {
  AudioLike entityToModel(AudioLikeEntity entity) {
    return AudioLike(
      localId: entity.id,
      audioId: entity.audioId,
      userId: entity.userId,
    );
  }

  AudioLike dtoToModel(AudioLikeDto dto) {
    return AudioLike(
      localId: null,
      audioId: dto.audioId,
      userId: dto.userId,
    );
  }

  AudioLikeEntity modelToEntity(AudioLike m) {
    return AudioLikeEntity(
      id: m.localId,
      audioId: m.audioId,
      userId: m.userId,
    );
  }
}
