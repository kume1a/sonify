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
  Future<int> deleteByIds(List<String> ids) async {
    return _db.delete(
      UserPlaylist_.tn,
      where: '${PlaylistAudio_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }

  @override
  Future<List<UserPlaylistEntity>> getAllByUserId(String userId) async {
    final res = await _db.query(
      UserPlaylist_.tn,
      where: '${UserPlaylist_.userId} = ?',
      whereArgs: [userId],
    );

    return res.map(_userPlaylistEntityMapper.mapToEntity).toList();
  }

  @override
  Future<List<String>> getAllIdsByUserId(String userId) {
    final res = _db.query(
      UserPlaylist_.tn,
      columns: [UserPlaylist_.id],
      where: '${UserPlaylist_.userId} = ?',
      whereArgs: [userId],
    );

    return res.then((value) => value.map((e) => e[UserPlaylist_.id] as String).toList());
  }
}
