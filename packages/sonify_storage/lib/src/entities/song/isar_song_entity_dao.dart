import 'package:isar/isar.dart';

import 'song_entity.dart';
import 'song_entity_dao.dart';

class IsarSongEntityDao implements SongEntityDao {
  IsarSongEntityDao(this._isar);

  final Isar _isar;

  @override
  Future<List<SongEntity>> getAll() {
    return _isar.collection<SongEntity>().where().findAll();
  }

  @override
  Future<void> insert(SongEntity entity) {
    return _isar.collection<SongEntity>().put(entity);
  }
}
