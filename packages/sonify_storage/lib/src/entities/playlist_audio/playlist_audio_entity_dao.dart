import '../../db/db_batch.dart';

import 'playlist_audio_entity.dart';

abstract interface class PlaylistAudioEntityDao {
  Future<String> insert(
    PlaylistAudioEntity entity, {
    DbBatchProvider? batchProvider,
  });

  Future<int> deleteByIds(List<String> ids);

  Future<List<PlaylistAudioEntity>> getAll({
    String? playlistId,
  });

  Future<List<String>> getAllIdsByPlaylistIds(
    List<String> playlistIds,
  );

  Future<List<PlaylistAudioEntity>> getAllWithAudio({
    required String playlistId,
  });
}
