import 'user_audio_entity.dart';

abstract interface class UserAudioEntityDao {
  Future<String> insert(UserAudioEntity entity);

  Future<List<UserAudioEntity>> getAllByUserId(String userId);

  Future<int> deleteByAudioIds(List<String> ids);

  Future<List<String>> getAllBAudioIdsByUserId(String userId);
}
