import 'package:sqflite/sqflite.dart';

import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'audio_entity.dart';
import 'audio_entity_dao.dart';
import 'audio_entity_mapper.dart';

class SqliteAudioEntityDao implements AudioEntityDao {
  SqliteAudioEntityDao(
    this._db,
    this._audioEntityMapper,
  );

  final Database _db;
  final AudioEntityMapper _audioEntityMapper;

  @override
  Future<String> insert(AudioEntity entity) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _audioEntityMapper.entityToMap(insertEntity);

    await _db.insert(Audio_.tn, entityMap);

    return insertEntity.id ?? kInvalidId;
  }
}
