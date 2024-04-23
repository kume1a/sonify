import 'audio_like_entity.dart';

abstract interface class AudioLikeEntityDao {
  Future<int> insert(AudioLikeEntity entity);

  Future<int> deleteByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<bool> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<List<AudioLikeEntity>> getAllByUserId(String userId);
}
