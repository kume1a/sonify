import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';

import '../../db/tables.dart';
import 'playlist_audio_entity.dart';
import 'playlist_audio_entity_mapper.dart';
import 'playlist_entity_dao.dart';

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
  Future<void> deleteMany(List<BAudioIdAndBPlaylistId> ids) {
    final batch = _db.batch();

    for (final id in ids) {
      batch.delete(
        PlaylistAudio_.tn,
        where: '${PlaylistAudio_.bAudioId} = ? AND ${PlaylistAudio_.bPlaylistId} = ?',
        whereArgs: [id.bAudioId, id.bPlaylistId],
      );
    }

    return batch.commit(noResult: true);
  }

  @override
  Future<List<BAudioIdAndBPlaylistId>> getAllBIds() async {
    final result = await _db.query(
      PlaylistAudio_.tn,
      columns: [
        PlaylistAudio_.bAudioId,
        PlaylistAudio_.bPlaylistId,
      ],
    );

    return result
        .map((m) {
          final bAudioId = m[PlaylistAudio_.bAudioId] as String?;
          final bPlaylistId = m[PlaylistAudio_.bPlaylistId] as String?;

          if (bAudioId == null || bPlaylistId == null) {
            return null;
          }

          return BAudioIdAndBPlaylistId(bAudioId: bAudioId, bPlaylistId: bPlaylistId);
        })
        .whereNotNull()
        .toList();
  }
}
