import '../../db/db_batch.dart';

import 'playlist_audio_entity.dart';

abstract interface class PlaylistAudioEntityDao {
  Future<String> insert(
    PlaylistAudioEntity entity, {
    DbBatchProvider? batchProvider,
  });

  Future<int> deleteByIds(List<String> ids);

  Future<void> deleteById(String id);

  Future<List<PlaylistAudioEntity>> getAll({
    String? playlistId,
  });

  Future<List<String>> getAllIdsByPlaylistIds(
    List<String> playlistIds,
  );

  Future<List<PlaylistAudioEntity>> getAllWithAudio({
    required String playlistId,
    String? searchQuery,
  });

  Future<int> countByAudioId(String id);

  Future<List<String>> getAudioIdsByIds(List<String> ids);

  Future<String?> getAudioIdById(String id);

  Future<List<PlaylistAudioEntity>> getAllByUserId(String userId);

  Future<int> countOnlyLocalPathPresentByUserId(String userId);

  Future<void> deleteByPlaylistId(
    String playlistId, {
    DbBatchProvider? batchProvider,
  });
}
