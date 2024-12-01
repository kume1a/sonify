import 'user_audio_entity.dart';

abstract interface class UserAudioEntityDao {
  Future<String> insert(UserAudioEntity entity);

  Future<List<UserAudioEntity>> getAll({
    required String userId,
    String? searchQuery,
  });

  Future<int> deleteByAudioIds(List<String> ids);

  Future<List<String>> getAllAudioIdsByUserId(String userId);

  Future<UserAudioEntity?> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<int> deleteById(String id);

  Future<UserAudioEntity?> getById(String id);

  Future<List<UserAudioEntity>> getByIds(List<String> ids);

  Future<int> countByAudioId(String id);

  Future<List<String>> getAudioIdsByIds(List<String> ids);

  Future<String?> getAudioIdById(String id);
}
