import '../../db/db_batch.dart';

import 'user_playlist_entity.dart';

abstract interface class UserPlaylistEntityDao {
  Future<String> insert(
    UserPlaylistEntity entity, {
    DbBatchProvider? batchProvider,
  });

  Future<void> deleteByUserIdAndPlaylistIds({
    required String userId,
    required List<String> playlistIds,
  });

  Future<List<String>> getAllPlaylistIdsByUserId(String bUserId);
}
