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
}
