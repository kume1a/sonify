import '../../db/db_batch.dart';

import 'playlist_audio_entity.dart';

abstract interface class PlaylistAudioEntityDao {
  Future<String> insert(
    PlaylistAudioEntity entity, {
    DbBatchProvider? batchProvider,
  });

  Future<void> deleteMany(List<PlaylistAudioEntity> entities);

  Future<List<PlaylistAudioEntity>> getAll();
}
