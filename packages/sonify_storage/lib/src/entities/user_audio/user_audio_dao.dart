import 'user_audio_entity.dart';

abstract interface class UserAudioEntityDao {
  Future<String> insert(UserAudioEntity entity);

  Future<List<UserAudioEntity>> getAllByUserId(String userId);

  Future<int> deleteByAudioIds(List<String> ids);

  Future<List<String>> getAllAudioIdsByUserId(String userId);

  Future<UserAudioEntity?> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });
}
