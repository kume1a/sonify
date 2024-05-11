import '../../db/db_batch.dart';

import '../playlist_audio/playlist_entity_dao.dart';
import 'user_playlist_entity.dart';

abstract interface class UserPlaylistEntityDao {
  void batchCreate(
    UserPlaylistEntity entity, {
    required DbBatchProvider batchProvider,
  });

  Future<void> deleteByBUserIdAndBPlaylistIds(String bUserId, List<String> bPlaylistIds);

  Future<List<String>> getAllBPlaylistIdsByBUserId(String bUserId);
}
