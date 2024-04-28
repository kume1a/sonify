import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
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
  Future<void> insert(
    AudioLikeEntity entity, [
    DbBatchProvider? batchProvider,
  ]) {
    final entityMap = _audioLikeEntityMapper.entityToMap(entity);

    if (batchProvider != null) {
      batchProvider.get.insert(AudioLike_.tn, entityMap);
      return Future.value();
    }

    return _db.insert(AudioLike_.tn, entityMap);
  }

  @override
  Future<int> deleteByUserIdAndAudioId({required String userId, required String audioId}) {
    return _db.delete(
      AudioLike_.tn,
      where: '${AudioLike_.bUserId} = ? AND ${AudioLike_.bAudioId} = ?',
      whereArgs: [userId, audioId],
    );
  }

  @override
  Future<bool> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.rawQuery(
      '''
      SELECT 
        COUNT(*) 
      FROM ${AudioLike_.tn}
      WHERE ${AudioLike_.bUserId} = ?
        AND ${AudioLike_.bAudioId} = ?;
    ''',
      [userId, audioId],
    );

    final count = Sqflite.firstIntValue(query);

    return count != null && count > 0;
  }

  @override
  Future<List<AudioLikeEntity>> getAllByUserId(String userId) async {
    final query = await _db.rawQuery(
      '''
      SELECT * FROM ${AudioLike_.tn}
        WHERE ${AudioLike_.bUserId} = ?;
      ''',
      [userId],
    );

    return query.map((e) => _audioLikeEntityMapper.mapToEntity(e)).toList();
  }

  @override
  Future<AudioLikeEntity?> getByUserAndAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.rawQuery(
      '''
      SELECT * FROM ${AudioLike_.tn}
        WHERE ${AudioLike_.bUserId} = ?
           AND ${AudioLike_.bAudioId} = ?;
      ''',
      [userId, audioId],
    );

    return query.isNotEmpty ? _audioLikeEntityMapper.mapToEntity(query.first) : null;
  }

  @override
  Future<int> deleteByBUserIdAndBAudioIds({
    required String userId,
    required List<String> bAudioIds,
  }) {
    return _db.delete(
      AudioLike_.tn,
      where: '''
        ${AudioLike_.bUserId} = ? 
        AND ${AudioLike_.bAudioId} IN ${sqlListPlaceholders(bAudioIds.length)}
      ''',
      whereArgs: [userId, ...bAudioIds],
    );
  }
}
