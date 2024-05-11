import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
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
  void batchCreate(PlaylistEntity playlist, {required DbBatchProvider batchProvider}) {
    final entityMap = _playlistEntityMapper.entityToMap(playlist);

    batchProvider.get.insert(
      Playlist_.tn,
      entityMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> deleteByBIds(List<String> bIds) {
    return _db.delete(
      Playlist_.tn,
      where: '${Playlist_.bId} IN ${sqlListPlaceholders(bIds.length)}',
      whereArgs: bIds,
    );
  }

  @override
  Future<List<String>> getAllBIds() async {
    final res = await _db.query(
      Playlist_.tn,
      columns: [Playlist_.bId],
    );

    return res.map((m) => m[Playlist_.bId] as String?).whereNotNull().toList();
  }
}
