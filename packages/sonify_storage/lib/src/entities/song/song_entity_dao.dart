import 'song_entity.dart';

abstract interface class SongEntityDao {
  Future<void> insert(SongEntity entity);

  Future<List<SongEntity>> getAll();
}
