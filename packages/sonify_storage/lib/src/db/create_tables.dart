import 'package:sqflite/sqflite.dart';

import 'tables.dart';

void createDbTables(Batch batch) {
  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${Audio_.tn} 
      (
        ${Audio_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${Audio_.bId} TEXT,
        ${Audio_.bCreatedAtMillis} INTEGER,
        ${Audio_.title} TEXT,
        ${Audio_.durationMs} INTEGER,
        ${Audio_.bPath} TEXT,
        ${Audio_.localPath} TEXT,
        ${Audio_.author} TEXT,
        ${Audio_.sizeBytes} INTEGER,
        ${Audio_.youtubeVideoId} TEXT,
        ${Audio_.spotifyId} TEXT,
        ${Audio_.bThumbnailPath} TEXT,
        ${Audio_.thumbnailUrl} TEXT,
        ${Audio_.localThumbnailPath} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${AudioLike_.tn}
      (
        ${AudioLike_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${AudioLike_.bAudioId} TEXT,
        ${AudioLike_.bUserId} TEXT
      )
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${DownloadedTask_.tn} 
      (
        ${DownloadedTask_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${DownloadedTask_.bUserId} TEXT,
        ${DownloadedTask_.taskId} TEXT,
        ${DownloadedTask_.savePath} TEXT,
        ${DownloadedTask_.fileType} TEXT,
        ${DownloadedTask_.payloadUserAudioId} INTEGER
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${UserAudio_.tn} 
      (
        ${UserAudio_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${UserAudio_.bCreatedAtMillis} INTEGER,
        ${UserAudio_.bUserId} TEXT,
        ${UserAudio_.bAudioId} TEXT,
        ${UserAudio_.audioId} INTEGER
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${PendingChange_.tn} 
      (
        ${PendingChange_.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${PendingChange_.type} TEXT,
        ${PendingChange_.payloadJSON} TEXT
      );
    ''',
  );
}
