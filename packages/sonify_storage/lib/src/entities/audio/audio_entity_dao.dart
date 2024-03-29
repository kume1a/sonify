import 'audio_entity.dart';

abstract interface class AudioEntityDao {
  Future<void> insert(AudioEntity entity);

  Future<List<AudioEntity>> getAllByUserId(String userId);

  Future<AudioEntity?> getById(int id);
}
