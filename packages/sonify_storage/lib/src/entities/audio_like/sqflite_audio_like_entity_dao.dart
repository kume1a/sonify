import 'package:sqflite/sqflite.dart';

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
  Future<int> insert(AudioLikeEntity entity) {
    return _db.insert(
      AudioLikeEntity_.tn,
      _audioLikeEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<int> deleteByUserIdAndAudioId({required String userId, required String audioId}) {
    return _db.delete(
      AudioLikeEntity_.tn,
      where: '${AudioLikeEntity_.bUserId} = ? AND ${AudioLikeEntity_.bAudioId} = ?',
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
      FROM ${AudioLikeEntity_.tn}
      WHERE ${AudioLikeEntity_.bUserId} = ?
        AND ${AudioLikeEntity_.bAudioId} = ?;
    ''',
      [userId, audioId],
    );

    final count = Sqflite.firstIntValue(query);

    return count != null && count > 0;
  }
}
