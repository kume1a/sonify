import '../../db/db_batch.dart';

import 'user_playlist_entity.dart';

abstract interface class UserPlaylistEntityDao {
  void batchCreate(
    UserPlaylistEntity entity, {
    required DbBatchProvider batchProvider,
  });

  Future<void> deleteByBUserIdAndBPlaylistIds({
    required String bUserId,
    required List<String> bPlaylistIds,
  });

  Future<List<String>> getAllBPlaylistIdsByBUserId(String bUserId);
}
