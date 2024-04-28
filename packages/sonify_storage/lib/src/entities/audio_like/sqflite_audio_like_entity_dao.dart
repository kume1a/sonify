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
  Future<int> deleteByBUserIdAndBAudioId({
    required String bUserId,
    required String bAudioId,
  }) {
    return _db.delete(
      AudioLike_.tn,
      where: '${AudioLike_.bUserId} = ? AND ${AudioLike_.bAudioId} = ?',
      whereArgs: [bUserId, bAudioId],
    );
  }

  @override
  Future<bool> existsByBUserIdAndBAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.query(
      AudioLike_.tn,
      columns: ['COUNT(*)'],
      where: '${AudioLike_.bUserId} = ? AND ${AudioLike_.bAudioId} = ?',
      whereArgs: [userId, audioId],
    );

    final count = Sqflite.firstIntValue(query);

    return count != null && count > 0;
  }

  @override
  Future<List<AudioLikeEntity>> getAllByBUserId(String userId) async {
    final query = await _db.query(
      AudioLike_.tn,
      where: '${AudioLike_.bUserId} = ?',
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
      where: '${AudioLike_.bUserId} = ? AND ${AudioLike_.bAudioId} = ?',
      whereArgs: [userId, audioId],
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
