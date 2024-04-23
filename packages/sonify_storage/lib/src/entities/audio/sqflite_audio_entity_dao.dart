import 'package:sqflite/sqflite.dart';

import '../../db/tables.dart';
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
  Future<int> insert(AudioEntity entity) async {
    return _db.insert(
      Audio_.tn,
      _audioEntityMapper.entityToMap(entity),
    );
  }
}
