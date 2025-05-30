import 'audio_entity.dart';

abstract interface class AudioEntityDao {
  Future<String> insert(AudioEntity entity);

  Future<List<AudioEntity>> getByIds(List<String> ids);

  Future<AudioEntity?> getById(String id);

  Future<void> nullOutLocalPathAndLocalThumbnailPathById(String id);
}
