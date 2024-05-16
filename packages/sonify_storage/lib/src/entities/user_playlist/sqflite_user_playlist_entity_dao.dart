import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
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
  Future<String> insert(
    UserPlaylistEntity entity, {
    DbBatchProvider? batchProvider,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _userPlaylistEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(UserPlaylist_.tn, entityMap);
    } else {
      await _db.insert(UserPlaylist_.tn, entityMap);
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByUserIdAndPlaylistIds({
    required String userId,
    required List<String> playlistIds,
  }) async {
    return _db.delete(
      UserPlaylist_.tn,
      where:
          '${UserPlaylist_.userId} = ? AND ${UserPlaylist_.playlistId} IN ${sqlListPlaceholders(playlistIds.length)}',
      whereArgs: [userId, ...playlistIds],
    );
  }

  @override
  Future<List<String>> getAllPlaylistIdsByUserId(String bUserId) async {
    final res = await _db.query(
      UserPlaylist_.tn,
      columns: [UserPlaylist_.playlistId],
      where: '${UserPlaylist_.userId} = ?',
      whereArgs: [bUserId],
    );

    return res.map((m) => m[UserPlaylist_.playlistId] as String?).whereNotNull().toList();
  }
}
