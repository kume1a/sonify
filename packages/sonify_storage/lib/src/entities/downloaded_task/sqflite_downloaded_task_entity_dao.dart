import 'package:sqflite/sqflite.dart';

import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
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
  Future<String> insert(
    DownloadedTaskEntity entity, {
    UserAudioEntity? payloadUserAudioEntity,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _downloadedTaskEntityMapper.entityToMap(insertEntity);

    await _db.insert(DownloadedTask_.tn, entityMap);

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<List<DownloadedTaskEntity>> getAllByUserId(String userId) async {
    final res = await _db.rawQuery(
      '''
      SELECT
        ${DownloadedTask_.tn}.*,
        ${UserAudio_.tn}.${UserAudio_.id} AS ${UserAudio_.joinedId},
        ${UserAudio_.tn}.${UserAudio_.createdAtMillis} AS ${UserAudio_.joinedCreatedAtMillis},
        ${UserAudio_.tn}.${UserAudio_.userId} AS ${UserAudio_.joinedUserId},
        ${UserAudio_.tn}.${UserAudio_.audioId} AS ${UserAudio_.joinedAudioId},
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
      FROM ${DownloadedTask_.tn}
      INNER JOIN ${UserAudio_.tn} ON ${DownloadedTask_.tn}.${DownloadedTask_.payloadUserAudioId} = ${UserAudio_.tn}.${UserAudio_.id}
      INNER JOIN ${Audio_.tn} ON ${UserAudio_.tn}.${UserAudio_.audioId} = ${Audio_.tn}.${Audio_.id}
      WHERE ${DownloadedTask_.tn}.${DownloadedTask_.userId} = ?;
    ''',
      [userId],
    );

    return res.map(_downloadedTaskEntityMapper.mapToEntity).toList();
  }
}
