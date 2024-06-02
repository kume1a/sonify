import '../../db/db_batch.dart';

import 'playlist_entity.dart';

abstract interface class PlaylistEntityDao {
  Future<String> insert(
    PlaylistEntity playlist, {
    DbBatchProvider? batchProvider,
  });

  Future<int> deleteByIds(List<String> bIds);

  Future<PlaylistEntity?> getById(String id);
}
