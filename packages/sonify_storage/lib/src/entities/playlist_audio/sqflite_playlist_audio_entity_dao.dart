import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'playlist_audio_entity.dart';
import 'playlist_audio_entity_dao.dart';
import 'playlist_audio_entity_mapper.dart';

class SqflitePlaylistAudioEntityDao implements PlaylistAudioEntityDao {
  SqflitePlaylistAudioEntityDao(
    this._db,
    this._playlistAudioEntityMapper,
  );

  final Database _db;
  final PlaylistAudioEntityMapper _playlistAudioEntityMapper;

  @override
  Future<String> insert(
    PlaylistAudioEntity entity, {
    DbBatchProvider? batchProvider,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _playlistAudioEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(PlaylistAudio_.tn, entityMap);
    } else {
      await _db.insert(PlaylistAudio_.tn, entityMap);
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByIds(List<String> ids) {
    return _db.delete(
      PlaylistAudio_.tn,
      where: '${PlaylistAudio_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }

  @override
  Future<List<PlaylistAudioEntity>> getAll() async {
    final result = await _db.query(PlaylistAudio_.tn);

    return result.map(_playlistAudioEntityMapper.mapToEntity).toList();
  }

  @override
  Future<List<String>> getAllIdsByPlaylistIds(List<String> playlistIds) async {
    final result = await _db.query(
      PlaylistAudio_.tn,
      columns: [PlaylistAudio_.id],
      where: '${PlaylistAudio_.playlistId} IN ${sqlListPlaceholders(playlistIds.length)}',
      whereArgs: playlistIds,
    );

    return result.map((e) => e[PlaylistAudio_.id] as String).toList();
  }
}
