import '../../db/db_batch.dart';

import 'playlist_entity.dart';

abstract interface class PlaylistEntityDao {
  Future<String> insert(
    PlaylistEntity playlist, {
    DbBatchProvider? batchProvider,
  });

  Future<int> deleteByIds(List<String> ids);

  Future<void> deleteById(
    String id, {
    DbBatchProvider? batchProvider,
  });

  Future<PlaylistEntity?> getById(String id);

  Future<void> updateById({
    required String id,
    String? name,
  });
}
