import '../../db/db_batch.dart';

import 'user_playlist_entity.dart';

abstract interface class UserPlaylistEntityDao {
  Future<String> insert(
    UserPlaylistEntity entity, {
    DbBatchProvider? batchProvider,
  });

  Future<void> deleteByIds(List<String> ids);

  Future<List<UserPlaylistEntity>> getAllByUserId(String userId);
}
