import 'package:sqflite/sqflite.dart';

import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'user_audio_dao.dart';
import 'user_audio_entity.dart';
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

    await _db.insert(UserAudio_.tn, entityMap);

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<List<UserAudioEntity>> getAllByUserId(String userId) async {
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
        ${AudioLike_.tn}.${AudioLike_.id} AS ${AudioLike_.joinedId}
      FROM ${UserAudio_.tn}
      INNER JOIN ${Audio_.tn} ON ${UserAudio_.tn}.${UserAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
      LEFT JOIN ${AudioLike_.tn} ON ${AudioLike_.tn}.${AudioLike_.userId} = ? 
        AND ${AudioLike_.tn}.${AudioLike_.audioId} = ${UserAudio_.tn}.${UserAudio_.audioId}
      WHERE ${UserAudio_.tn}.${UserAudio_.userId} = ?
      ORDER BY ${Audio_.tn}.${Audio_.title};
      ''',
      [userId, userId],
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
  Future<List<String>> getAllBAudioIdsByUserId(String userId) async {
    final query = await _db.query(
      UserAudio_.tn,
      columns: [UserAudio_.audioId],
      where: '${UserAudio_.userId} = ?',
      whereArgs: [userId],
    );

    return query.map((e) => e[UserAudio_.audioId] as String).toList();
  }
}
