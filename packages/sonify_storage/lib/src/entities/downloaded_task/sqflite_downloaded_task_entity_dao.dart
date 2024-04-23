import 'package:sqflite/sqflite.dart';

import '../../db/tables.dart';
import '../user_audio/user_audio_entity.dart';
import 'downloaded_task_entity.dart';
import 'downloaded_task_entity_dao.dart';
import 'downloaded_task_entity_mapper.dart';

class SqfliteDownloadedTaskEntityDao implements DownloadedTaskEntityDao {
  SqfliteDownloadedTaskEntityDao(
    this._db,
    this._downloadedTaskEntityMapper,
  );

  final Database _db;
  final DownloadedTaskEntityMapper _downloadedTaskEntityMapper;

  @override
  Future<int> insert(
    DownloadedTaskEntity entity, {
    UserAudioEntity? payloadUserAudioEntity,
  }) {
    return _db.insert(
      UserAudioEntity_.tn,
      _downloadedTaskEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<List<DownloadedTaskEntity>> getAllByUserId(String userId) async {
    final res = await _db.rawQuery(
      '''
      SELECT
        ${DownloadedTaskEntity_.tn}.*,
        ${UserAudioEntity_.tn}.${UserAudioEntity_.id} AS ${UserAudioEntity_.joinedId},
        ${UserAudioEntity_.tn}.${UserAudioEntity_.bCreatedAtMillis} AS ${UserAudioEntity_.joinedBCreatedAtMillis},
        ${UserAudioEntity_.tn}.${UserAudioEntity_.bUserId} AS ${UserAudioEntity_.joinedBUserId},
        ${UserAudioEntity_.tn}.${UserAudioEntity_.bAudioId} AS ${UserAudioEntity_.joinPrefix} ,
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
      FROM ${DownloadedTaskEntity_.tn}
      INNER JOIN ${UserAudioEntity_.tn} ON ${DownloadedTaskEntity_.tn}.${DownloadedTaskEntity_.payloadUserAudioId} = ${UserAudioEntity_.tn}.${UserAudioEntity_.id}
      INNER JOIN ${AudioEntity_.tn} ON ${UserAudioEntity_.tn}.${UserAudioEntity_.audioId} = ${AudioEntity_.tn}.${AudioEntity_.id}
      WHERE ${DownloadedTaskEntity_.tn}.${DownloadedTaskEntity_.bUserId} = ?;
    ''',
      [userId],
    );

    return res.map(_downloadedTaskEntityMapper.mapToEntity).toList();
  }
}
