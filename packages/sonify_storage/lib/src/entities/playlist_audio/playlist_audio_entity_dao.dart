import '../../db/db_batch.dart';

import 'playlist_audio_entity.dart';

abstract interface class PlaylistAudioEntityDao {
  void batchCreate(
    PlaylistAudioEntity entity, {
    required DbBatchProvider batchProvider,
  });

  Future<void> deleteMany(List<PlaylistAudioEntity> entities);

  Future<List<PlaylistAudioEntity>> getAll();
}
