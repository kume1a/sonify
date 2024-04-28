import '../../db/db_batch.dart';
import 'audio_like_entity.dart';

abstract interface class AudioLikeEntityDao {
  Future<void> insert(
    AudioLikeEntity entity, [
    DbBatchProvider? batchProvider,
  ]);

  Future<int> deleteByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<bool> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<List<AudioLikeEntity>> getAllByUserId(String userId);

  Future<AudioLikeEntity?> getByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<int> deleteByBUserIdAndBAudioIds({
    required String userId,
    required List<String> bAudioIds,
  });
}
