import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
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
  Future<String> insert(
    PlaylistAudioEntity entity, {
    DbBatchProvider? batchProvider,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _playlistAudioEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(
        PlaylistAudio_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _db.insert(
        PlaylistAudio_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByIds(List<String> ids) {
    return _db.delete(
      PlaylistAudio_.tn,
      where: '${PlaylistAudio_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }

  @override
  Future<List<PlaylistAudioEntity>> getAll({
    String? playlistId,
  }) async {
    final result = await _db.query(
      PlaylistAudio_.tn,
      where: playlistId != null ? '${PlaylistAudio_.playlistId} = ?' : null,
      whereArgs: playlistId != null ? [playlistId] : null,
    );

    return result.map(_playlistAudioEntityMapper.mapToEntity).toList();
  }

  @override
  Future<List<String>> getAllIdsByPlaylistIds(List<String> playlistIds) async {
    final result = await _db.query(
      PlaylistAudio_.tn,
      columns: [PlaylistAudio_.id],
      where: '${PlaylistAudio_.playlistId} IN ${sqlListPlaceholders(playlistIds.length)}',
      whereArgs: playlistIds,
    );

    return result.map((e) => e[PlaylistAudio_.id] as String).toList();
  }

  @override
  Future<List<PlaylistAudioEntity>> getAllWithAudio({
    required String playlistId,
    String? searchQuery,
  }) async {
    final searchQueryExists = searchQuery != null && searchQuery.isNotEmpty;

    final dynamicSearchQueryCondition = searchQueryExists
        ? 'AND (${Audio_.tn}.${Audio_.title} LIKE ?) OR (${Audio_.tn}.${Audio_.author} LIKE ?)'
        : '';

    final res = await _db.rawQuery(
      '''
        SELECT 
          ${PlaylistAudio_.tn}.${PlaylistAudio_.id},
          ${PlaylistAudio_.tn}.${PlaylistAudio_.createdAtMillis},
          ${PlaylistAudio_.tn}.${PlaylistAudio_.playlistId},
          ${PlaylistAudio_.tn}.${PlaylistAudio_.audioId},

          ${Audio_.tn}.${Audio_.id} AS ${Audio_.joinedId},
          ${Audio_.tn}.${Audio_.createdAtMillis} AS ${Audio_.joinedCreatedAtMillis},
          ${Audio_.tn}.${Audio_.title} AS ${Audio_.joinedTitle},
          ${Audio_.tn}.${Audio_.durationMs} AS ${Audio_.joinedDurationMs},
          ${Audio_.tn}.${Audio_.path} AS ${Audio_.joinedPath},
          ${Audio_.tn}.${Audio_.localPath} AS ${Audio_.joinedLocalPath},
          ${Audio_.tn}.${Audio_.author} AS ${Audio_.joinedAuthor},
          ${Audio_.tn}.${Audio_.sizeBytes} AS ${Audio_.joinedSizeBytes},
          ${Audio_.tn}.${Audio_.youtubeVideoId} AS ${Audio_.joinedYoutubeVideoId},
          ${Audio_.tn}.${Audio_.spotifyId} AS ${Audio_.joinedSpotifyId},
          ${Audio_.tn}.${Audio_.thumbnailPath} AS ${Audio_.joinedThumbnailPath},
          ${Audio_.tn}.${Audio_.thumbnailUrl} AS ${Audio_.joinedThumbnailUrl},
          ${Audio_.tn}.${Audio_.localThumbnailPath} AS ${Audio_.joinedLocalThumbnailPath}
        FROM ${PlaylistAudio_.tn}
        LEFT JOIN ${Audio_.tn} ON ${PlaylistAudio_.tn}.${PlaylistAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
        WHERE ${PlaylistAudio_.tn}.${PlaylistAudio_.playlistId} = ?
          $dynamicSearchQueryCondition
        ORDER BY ${Audio_.tn}.${Audio_.title} ASC;
      ''',
      [
        playlistId,
        if (searchQueryExists) '%$searchQuery%',
        if (searchQueryExists) '%$searchQuery%',
      ],
    );

    return res.map(_playlistAudioEntityMapper.mapToEntity).toList();
  }
}
