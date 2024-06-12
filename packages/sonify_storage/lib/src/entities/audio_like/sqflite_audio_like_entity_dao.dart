import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'audio_like_entity.dart';
import 'audio_like_entity_dao.dart';
import 'audio_like_entity_mapper.dart';

class SqfliteAudioLikeEntityDao implements AudioLikeEntityDao {
  SqfliteAudioLikeEntityDao(
    this._db,
    this._audioLikeEntityMapper,
  );

  final Database _db;
  final AudioLikeEntityMapper _audioLikeEntityMapper;

  @override
  Future<String> insert(
    AudioLikeEntity entity, [
    DbBatchProvider? batchProvider,
  ]) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _audioLikeEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(
        AudioLike_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _db.insert(
        AudioLike_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return _db.delete(
      AudioLike_.tn,
      where: '${AudioLike_.userId} = ? AND ${AudioLike_.audioId} = ?',
      whereArgs: [userId, audioId],
    );
  }

  @override
  Future<bool> existsByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.query(
      AudioLike_.tn,
      columns: ['COUNT(*)'],
      where: '${AudioLike_.userId} = ? AND ${AudioLike_.audioId} = ?',
      whereArgs: [userId, audioId],
    );

    final count = Sqflite.firstIntValue(query);

    return count != null && count > 0;
  }

  @override
  Future<List<AudioLikeEntity>> getAllByUserId(String userId) async {
    final query = await _db.query(
      AudioLike_.tn,
      where: '${AudioLike_.userId} = ?',
      whereArgs: [userId],
    );

    return query.map((e) => _audioLikeEntityMapper.mapToEntity(e)).toList();
  }

  @override
  Future<AudioLikeEntity?> getByUserAndAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.query(
      AudioLike_.tn,
      where: '${AudioLike_.userId} = ? AND ${AudioLike_.audioId} = ?',
      whereArgs: [userId, audioId],
    );

    return query.isNotEmpty ? _audioLikeEntityMapper.mapToEntity(query.first) : null;
  }

  @override
  Future<int> deleteByIds(List<String> ids) {
    return _db.delete(
      AudioLike_.tn,
      where: '${AudioLike_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }
}
