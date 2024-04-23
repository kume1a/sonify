import 'audio_entity.dart';

abstract interface class AudioEntityDao {
  Future<int> insert(AudioEntity entity);
}
