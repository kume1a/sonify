import 'package:sqflite/sqflite.dart';

import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'user_audio_entity.dart';
import 'user_audio_entity_dao.dart';
import 'user_audio_entity_mapper.dart';

class SqfliteUserAudioEntityDao implements UserAudioEntityDao {
  SqfliteUserAudioEntityDao(
    this._db,
    this._userAudioEntityMapper,
  );

  final Database _db;
  final UserAudioEntityMapper _userAudioEntityMapper;

  @override
  Future<String> insert(UserAudioEntity entity) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _userAudioEntityMapper.entityToMap(insertEntity);

    await _db.insert(
      UserAudio_.tn,
      entityMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<List<UserAudioEntity>> getAll({
    required String userId,
    String? searchQuery,
  }) async {
    final searchQueryExists = searchQuery != null && searchQuery.isNotEmpty;

    final dynamicSearchQueryCondition = searchQueryExists
        ? 'AND (${Audio_.tn}.${Audio_.title} LIKE ?) OR (${Audio_.tn}.${Audio_.author} LIKE ?)'
        : '';

    final res = await _db.rawQuery(
      '''
      SELECT 
        ${UserAudio_.tn}.*,
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
        ${Audio_.tn}.${Audio_.localThumbnailPath} AS ${Audio_.joinedLocalThumbnailPath},
        ${AudioLike_.tn}.${AudioLike_.id} AS ${AudioLike_.joinedId},
        ${AudioLike_.tn}.${AudioLike_.userId} AS ${AudioLike_.joinedUserId},
        ${AudioLike_.tn}.${AudioLike_.audioId} AS ${AudioLike_.joinedAudioId}
      FROM ${UserAudio_.tn}
      INNER JOIN ${Audio_.tn} ON ${UserAudio_.tn}.${UserAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
      LEFT JOIN ${AudioLike_.tn} ON ${AudioLike_.tn}.${AudioLike_.userId} = ? 
       AND ${AudioLike_.tn}.${AudioLike_.audioId} = ${UserAudio_.tn}.${UserAudio_.audioId}
      WHERE ${UserAudio_.tn}.${UserAudio_.userId} = ? 
        $dynamicSearchQueryCondition
      ORDER BY ${Audio_.tn}.${Audio_.title};
      ''',
      [
        userId,
        userId,
        if (searchQueryExists) '%$searchQuery%',
        if (searchQueryExists) '%$searchQuery%',
      ],
    );

    return res.map(_userAudioEntityMapper.mapToEntity).toList();
  }

  @override
  Future<int> deleteByAudioIds(List<String> audioIds) {
    return _db.delete(
      UserAudio_.tn,
      where: '${UserAudio_.audioId} IN ${sqlListPlaceholders(audioIds.length)}',
      whereArgs: audioIds,
    );
  }

  @override
  Future<List<String>> getAllAudioIdsByUserId(String userId) async {
    final query = await _db.query(
      UserAudio_.tn,
      columns: [UserAudio_.audioId],
      where: '${UserAudio_.userId} = ?',
      whereArgs: [userId],
    );

    return query.map((e) => e[UserAudio_.audioId] as String).toList();
  }

  @override
  Future<UserAudioEntity?> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) async {
    final query = await _db.query(
      UserAudio_.tn,
      where: '${UserAudio_.userId} = ? AND ${UserAudio_.audioId} = ?',
      whereArgs: [userId, audioId],
    );

    return query.isNotEmpty ? _userAudioEntityMapper.mapToEntity(query.first) : null;
  }

  @override
  Future<int> deleteById(String id) {
    return _db.delete(
      UserAudio_.tn,
      where: '${UserAudio_.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<UserAudioEntity?> getById(String id) async {
    final res = await _db.rawQuery(
      '''
      SELECT 
        ${UserAudio_.tn}.*,
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
        ${Audio_.tn}.${Audio_.localThumbnailPath} AS ${Audio_.joinedLocalThumbnailPath},
        ${AudioLike_.tn}.${AudioLike_.id} AS ${AudioLike_.joinedId},
        ${AudioLike_.tn}.${AudioLike_.userId} AS ${AudioLike_.joinedUserId},
        ${AudioLike_.tn}.${AudioLike_.audioId} AS ${AudioLike_.joinedAudioId}
      FROM ${UserAudio_.tn}
      INNER JOIN ${Audio_.tn} ON ${UserAudio_.tn}.${UserAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
      LEFT JOIN ${AudioLike_.tn} ON ${AudioLike_.tn}.${AudioLike_.userId} = ${UserAudio_.tn}.${UserAudio_.userId}
       AND ${AudioLike_.tn}.${AudioLike_.audioId} = ${UserAudio_.tn}.${UserAudio_.audioId}
      WHERE ${UserAudio_.tn}.${UserAudio_.id} = ?
      LIMIT 1;
      ''',
      [id],
    );

    return res.map(_userAudioEntityMapper.mapToEntity).toList().firstOrNull;
  }

  @override
  Future<List<UserAudioEntity>> getByIds(List<String> ids) async {
    final res = await _db.rawQuery(
      '''
      SELECT 
        ${UserAudio_.tn}.*,
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
        ${Audio_.tn}.${Audio_.localThumbnailPath} AS ${Audio_.joinedLocalThumbnailPath},
        ${AudioLike_.tn}.${AudioLike_.id} AS ${AudioLike_.joinedId},
        ${AudioLike_.tn}.${AudioLike_.userId} AS ${AudioLike_.joinedUserId},
        ${AudioLike_.tn}.${AudioLike_.audioId} AS ${AudioLike_.joinedAudioId}
      FROM ${UserAudio_.tn}
      INNER JOIN ${Audio_.tn} ON ${UserAudio_.tn}.${UserAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
      LEFT JOIN ${AudioLike_.tn} ON ${AudioLike_.tn}.${AudioLike_.userId} = ${UserAudio_.tn}.${UserAudio_.userId}
       AND ${AudioLike_.tn}.${AudioLike_.audioId} = ${UserAudio_.tn}.${UserAudio_.audioId}
      WHERE ${UserAudio_.tn}.${UserAudio_.id} IN ${sqlListPlaceholders(ids.length)}
      ''',
      ids,
    );

    return res.map(_userAudioEntityMapper.mapToEntity).toList();
  }

  @override
  Future<int> countByAudioId(String id) async {
    final res = await _db.query(
      UserAudio_.tn,
      columns: ['COUNT(1)'],
      where: '${UserAudio_.audioId} = ?',
      whereArgs: [id],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  @override
  Future<List<String>> getAudioIdsByIds(List<String> ids) {
    final res = _db.query(
      UserAudio_.tn,
      columns: [UserAudio_.audioId],
      where: '${UserAudio_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );

    return res.then((value) => value.map((e) => e[UserAudio_.audioId] as String).toList());
  }

  @override
  Future<String?> getAudioIdById(String id) async {
    final res = await _db.query(
      UserAudio_.tn,
      columns: [UserAudio_.audioId],
      where: '${UserAudio_.id} = ?',
      whereArgs: [id],
    );

    return res.map((e) => e[UserAudio_.audioId] as String).firstOrNull;
  }

  @override
  Future<int> getCountByUserId(String userId) async {
    final res = await _db.query(
      UserAudio_.tn,
      columns: ['COUNT(1)'],
      where: '${UserAudio_.userId} = ?',
      whereArgs: [userId],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  @override
  Future<void> deleteByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return _db.delete(
      UserAudio_.tn,
      where: '${UserAudio_.userId} = ? AND ${UserAudio_.audioId} = ?',
      whereArgs: [userId, audioId],
    );
  }
}
