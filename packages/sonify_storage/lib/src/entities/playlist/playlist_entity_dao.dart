import '../../db/db_batch.dart';

import 'playlist_entity.dart';

abstract interface class PlaylistEntityDao {
  void batchCreate(
    PlaylistEntity playlist, {
    required DbBatchProvider batchProvider,
  });

  Future<int> deleteByBIds(List<String> bIds);

  Future<List<String>> getAllBIds();
}
