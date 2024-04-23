import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio_like.dart';

class AudioLikeMapper {
  AudioLike entityToModel(AudioLikeEntity entity) {
    return AudioLike(
      localId: entity.id,
      audioId: entity.bAudioId,
      userId: entity.bUserId,
    );
  }
}
