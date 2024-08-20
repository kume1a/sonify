import 'package:sqflite/sqflite.dart';

import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'hidden_user_audio_dao.dart';
import 'hidden_user_audio_entity.dart';
import 'hidden_user_audio_entity_mapper.dart';

class SqfliteHiddenUserAudioEntityDao implements HiddenUserAudioEntityDao {
  SqfliteHiddenUserAudioEntityDao(
    this._db,
    this._hiddenUserAudioEntityMapper,
  );

  final Database _db;
  final HiddenUserAudioEntityMapper _hiddenUserAudioEntityMapper;

  @override
  Future<String> insert(HiddenUserAudioEntity entity) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _hiddenUserAudioEntityMapper.entityToMap(insertEntity);

    await _db.insert(
      HiddenUserAudio_.tn,
      entityMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByAudioIds(List<String> audioIds) {
    return _db.delete(
      HiddenUserAudio_.tn,
      where: '${HiddenUserAudio_.audioId} IN ${sqlListPlaceholders(audioIds.length)}',
      whereArgs: audioIds,
    );
  }

  @override
  Future<List<String>> getAllAudioIdsByUserId(String userId) async {
    final query = await _db.query(
      HiddenUserAudio_.tn,
      columns: [HiddenUserAudio_.audioId],
      where: '${HiddenUserAudio_.userId} = ?',
      whereArgs: [userId],
    );

    return query.map((e) => e[HiddenUserAudio_.audioId] as String).toList();
  }
}
