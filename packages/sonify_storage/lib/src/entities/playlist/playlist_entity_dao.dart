import '../../db/db_batch.dart';

import 'playlist_entity.dart';

abstract interface class PlaylistEntityDao {
  void batchCreate(
    PlaylistEntity playlist, {
    required DbBatchProvider batchProvider,
  });

  Future<int> deleteByIds(List<String> bIds);

  Future<List<String>> getAllIds();
}
