import 'package:sqflite/sqflite.dart';

import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
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
  Future<int> insert(UserAudioEntity entity) {
    return _db.insert(
      UserAudioEntity_.tn,
      _userAudioEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<List<UserAudioEntity>> getAllByUserId(String userId) async {
    final res = await _db.rawQuery(
      '''
      SELECT 
        ${UserAudioEntity_.tn}.*,
        ${AudioEntity_.tn}.${AudioEntity_.id} AS ${AudioEntity_.joinedId},
        ${AudioEntity_.tn}.${AudioEntity_.bId} AS ${AudioEntity_.joinedBId},
        ${AudioEntity_.tn}.${AudioEntity_.bCreatedAtMillis} AS ${AudioEntity_.joinedBCreatedAtMillis},
        ${AudioEntity_.tn}.${AudioEntity_.title} AS ${AudioEntity_.joinedTitle},
        ${AudioEntity_.tn}.${AudioEntity_.durationMs} AS ${AudioEntity_.joinedDurationMs},
        ${AudioEntity_.tn}.${AudioEntity_.bPath} AS ${AudioEntity_.joinedBPath},
        ${AudioEntity_.tn}.${AudioEntity_.localPath} AS ${AudioEntity_.joinedLocalPath},
        ${AudioEntity_.tn}.${AudioEntity_.author} AS ${AudioEntity_.joinedAuthor},
        ${AudioEntity_.tn}.${AudioEntity_.sizeBytes} AS ${AudioEntity_.joinedSizeBytes},
        ${AudioEntity_.tn}.${AudioEntity_.youtubeVideoId} AS ${AudioEntity_.joinedYoutubeVideoId},
        ${AudioEntity_.tn}.${AudioEntity_.spotifyId} AS ${AudioEntity_.joinedSpotifyId},
        ${AudioEntity_.tn}.${AudioEntity_.bThumbnailPath} AS ${AudioEntity_.joinedBThumbnailPath},
        ${AudioEntity_.tn}.${AudioEntity_.thumbnailUrl} AS ${AudioEntity_.joinedThumbnailUrl},
        ${AudioEntity_.tn}.${AudioEntity_.localThumbnailPath} AS ${AudioEntity_.joinedLocalThumbnailPath}
      FROM ${UserAudioEntity_.tn}
      INNER JOIN ${AudioEntity_.tn} ON ${UserAudioEntity_.tn}.${UserAudioEntity_.audioId} = ${AudioEntity_.tn}.${AudioEntity_.id}
      WHERE ${UserAudioEntity_.tn}.${UserAudioEntity_.bUserId} = ?;
      ''',
      [userId],
    );

    return res.map(_userAudioEntityMapper.mapToEntity).toList();
  }

  @override
  Future<int> deleteByIds(List<int> ids) {
    return _db.rawDelete(
      '''
      DELETE FROM ${UserAudioEntity_.tn}
      WHERE ${UserAudioEntity_.id} IN ${sqlListPlaceholders(ids.length)};
      ''',
      ids,
    );
  }
}
