import 'user_audio_entity.dart';

abstract interface class UserAudioEntityDao {
  Future<List<UserAudioEntity>> getAllByUserId(String userId);

  Future<int> deleteByIds(List<int> ids);
}
