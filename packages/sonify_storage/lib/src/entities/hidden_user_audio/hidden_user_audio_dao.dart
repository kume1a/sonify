import 'hidden_user_audio_entity.dart';

abstract interface class HiddenUserAudioEntityDao {
  Future<String> insert(HiddenUserAudioEntity entity);

  Future<int> deleteByAudioIds(List<String> ids);

  Future<List<String>> getAllAudioIdsByUserId(String userId);
}
