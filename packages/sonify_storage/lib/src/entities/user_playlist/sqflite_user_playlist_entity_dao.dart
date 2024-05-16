import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import 'user_playlist_entity.dart';
import 'user_playlist_entity_dao.dart';
import 'user_playlist_entity_mapper.dart';

class SqfliteUserPlaylistEntityDao implements UserPlaylistEntityDao {
  SqfliteUserPlaylistEntityDao(
    this._db,
    this._userPlaylistEntityMapper,
  );

  final Database _db;
  final UserPlaylistEntityMapper _userPlaylistEntityMapper;

  @override
  void batchCreate(
    UserPlaylistEntity entity, {
    required DbBatchProvider batchProvider,
  }) {
    return batchProvider.get.insert(
      UserPlaylist_.tn,
      _userPlaylistEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<int> deleteByBUserIdAndBPlaylistIds({
    required String bUserId,
    required List<String> bPlaylistIds,
  }) async {
    return _db.delete(
      UserPlaylist_.tn,
      where:
          '${UserPlaylist_.userId} = ? AND ${UserPlaylist_.playlistId} IN ${sqlListPlaceholders(bPlaylistIds.length)}',
      whereArgs: [bUserId, ...bPlaylistIds],
    );
  }

  @override
  Future<List<String>> getAllBPlaylistIdsByBUserId(String bUserId) async {
    final res = await _db.query(
      UserPlaylist_.tn,
      columns: [UserPlaylist_.playlistId],
      where: '${UserPlaylist_.userId} = ?',
      whereArgs: [bUserId],
    );

    return res.map((m) => m[UserPlaylist_.playlistId] as String?).whereNotNull().toList();
  }
}
