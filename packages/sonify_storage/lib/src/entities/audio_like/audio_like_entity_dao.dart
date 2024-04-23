import 'audio_like_entity.dart';

abstract interface class AudioLikeEntityDao {
  Future<int> insert(AudioLikeEntity entity);
}
