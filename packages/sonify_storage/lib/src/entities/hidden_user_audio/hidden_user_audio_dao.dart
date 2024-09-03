import '../../db/db_batch.dart';
import 'hidden_user_audio_entity.dart';

abstract interface class HiddenUserAudioEntityDao {
  Future<String> insert(
    HiddenUserAudioEntity entity, [
    DbBatchProvider? batchProvider,
  ]);

  Future<int> deleteByAudioIds(List<String> ids);

  Future<List<String>> getAllAudioIdsByUserId(String userId);

  Future<int> deleteByIds(List<String> ids);
}
