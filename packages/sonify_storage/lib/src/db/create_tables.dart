import 'package:sqflite/sqflite.dart';

import 'tables.dart';

void createDbTables(Batch batch) {
  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${AudioEntity_.tn} 
      (
        ${AudioEntity_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${AudioEntity_.bId} TEXT,
        ${AudioEntity_.bCreatedAtMillis} INTEGER,
        ${AudioEntity_.title} TEXT,
        ${AudioEntity_.durationMs} INTEGER,
        ${AudioEntity_.bPath} TEXT,
        ${AudioEntity_.localPath} TEXT,
        ${AudioEntity_.author} TEXT,
        ${AudioEntity_.sizeBytes} INTEGER,
        ${AudioEntity_.youtubeVideoId} TEXT,
        ${AudioEntity_.spotifyId} TEXT,
        ${AudioEntity_.bThumbnailPath} TEXT,
        ${AudioEntity_.thumbnailUrl} TEXT,
        ${AudioEntity_.localThumbnailPath} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${AudioLikeEntity_.tn}
      (
        ${AudioLikeEntity_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${AudioLikeEntity_.bAudioId} TEXT,
        ${AudioLikeEntity_.bUserId} TEXT
      )
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${DownloadedTaskEntity_.tn} 
      (
        ${DownloadedTaskEntity_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${DownloadedTaskEntity_.bUserId} TEXT,
        ${DownloadedTaskEntity_.taskId} TEXT,
        ${DownloadedTaskEntity_.savePath} TEXT,
        ${DownloadedTaskEntity_.fileType} TEXT,
        ${DownloadedTaskEntity_.payloadUserAudioId} INTEGER
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${UserAudioEntity_.tn} 
      (
        ${UserAudioEntity_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${UserAudioEntity_.bCreatedAtMillis} INTEGER,
        ${UserAudioEntity_.bUserId} TEXT,
        ${UserAudioEntity_.bAudioId} TEXT,
        ${UserAudioEntity_.audioId} INTEGER
      );
    ''',
  );
}
