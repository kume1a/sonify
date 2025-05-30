import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'playlist_entity.dart';
import 'playlist_entity_dao.dart';
import 'playlist_entity_mapper.dart';

class SqflitePlaylistEntityDao implements PlaylistEntityDao {
  SqflitePlaylistEntityDao(
    this._db,
    this._playlistEntityMapper,
  );

  final Database _db;
  final PlaylistEntityMapper _playlistEntityMapper;

  @override
  Future<String> insert(
    PlaylistEntity entity, {
    DbBatchProvider? batchProvider,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _playlistEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(
        Playlist_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _db.insert(
        Playlist_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByIds(List<String> ids) {
    return _db.delete(
      Playlist_.tn,
      where: '${Playlist_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }

  @override
  Future<void> deleteById(
    String id, {
    DbBatchProvider? batchProvider,
  }) async {
    if (batchProvider != null) {
      batchProvider.get.delete(
        Playlist_.tn,
        where: '${Playlist_.id} = ?',
        whereArgs: [id],
      );
    } else {
      await _db.delete(
        Playlist_.tn,
        where: '${Playlist_.id} = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<PlaylistEntity?> getById(String id) async {
    final res = await _db.query(
      Playlist_.tn,
      where: '${Playlist_.id} = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? _playlistEntityMapper.mapToEntity(res.first) : null;
  }

  @override
  Future<void> updateById({
    required String id,
    String? name,
  }) {
    final updateMap = <String, dynamic>{
      if (name != null) Playlist_.name: name,
    };

    return _db.update(
      Playlist_.tn,
      updateMap,
      where: '${Playlist_.id} = ?',
      whereArgs: [id],
    );
  }
}
