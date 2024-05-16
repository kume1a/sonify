import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/tables.dart';
import 'playlist_audio_entity.dart';
import 'playlist_audio_entity_dao.dart';
import 'playlist_audio_entity_mapper.dart';

class SqflitePlaylistAudioEntityDao implements PlaylistAudioEntityDao {
  SqflitePlaylistAudioEntityDao(
    this._db,
    this._playlistAudioEntityMapper,
  );

  final Database _db;
  final PlaylistAudioEntityMapper _playlistAudioEntityMapper;

  @override
  void batchCreate(
    PlaylistAudioEntity entity, {
    required DbBatchProvider batchProvider,
  }) {
    return batchProvider.get.insert(
      PlaylistAudio_.tn,
      _playlistAudioEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<void> deleteMany(List<PlaylistAudioEntity> entities) {
    final batch = _db.batch();

    for (final entity in entities) {
      batch.delete(
        PlaylistAudio_.tn,
        where: '${PlaylistAudio_.audioId} = ? AND ${PlaylistAudio_.playlistId} = ?',
        whereArgs: [entity.audioId, entity.playlistId],
      );
    }

    return batch.commit(noResult: true);
  }

  @override
  Future<List<PlaylistAudioEntity>> getAll() async {
    final result = await _db.query(PlaylistAudio_.tn);

    return result.map(_playlistAudioEntityMapper.mapToEntity).toList();
  }
}
