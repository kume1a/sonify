import 'package:sqflite/sqflite.dart';

import 'tables.dart';

void createDbTables(Batch batch) {
  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${Audio_.tn} 
      (
        ${Audio_.id} TEXT PRIMARY KEY NOT NULL,
        ${Audio_.createdAtMillis} INTEGER,
        ${Audio_.title} TEXT,
        ${Audio_.durationMs} INTEGER,
        ${Audio_.path} TEXT,
        ${Audio_.localPath} TEXT,
        ${Audio_.author} TEXT,
        ${Audio_.sizeBytes} INTEGER,
        ${Audio_.youtubeVideoId} TEXT,
        ${Audio_.spotifyId} TEXT,
        ${Audio_.thumbnailPath} TEXT,
        ${Audio_.thumbnailUrl} TEXT,
        ${Audio_.localThumbnailPath} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${AudioLike_.tn}
      (
        ${AudioLike_.id} TEXT PRIMARY KEY NOT NULL,
        ${AudioLike_.audioId} TEXT,
        ${AudioLike_.userId} TEXT
      )
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${DownloadedTask_.tn} 
      (
        ${DownloadedTask_.id} TEXT PRIMARY KEY NOT NULL,
        ${DownloadedTask_.userId} TEXT,
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
        ${UserAudio_.id} TEXT PRIMARY KEY NOT NULL,
        ${UserAudio_.createdAtMillis} INTEGER,
        ${UserAudio_.userId} TEXT,
        ${UserAudio_.audioId} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${PendingChange_.tn} 
      (
        ${PendingChange_.id} TEXT PRIMARY KEY NOT NULL,
        ${PendingChange_.type} TEXT,
        ${PendingChange_.payloadJSON} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${Playlist_.tn} 
      (
        ${Playlist_.id} TEXT PRIMARY KEY NOT NULL,
        ${Playlist_.createdAtMillis} INTEGER,
        ${Playlist_.name} TEXT,
        ${Playlist_.thumbnailPath} TEXT,
        ${Playlist_.thumbnailUrl} TEXT,
        ${Playlist_.spotifyId} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${PlaylistAudio_.tn} 
      (
        ${PlaylistAudio_.id} TEXT PRIMARY KEY NOT NULL,
        ${PlaylistAudio_.createdAtMillis} INTEGER,
        ${PlaylistAudio_.playlistId} TEXT,
        ${PlaylistAudio_.audioId} TEXT
      );
    ''',
  );

  batch.execute(
    '''
      CREATE TABLE IF NOT EXISTS ${UserPlaylist_.tn} 
      (
        ${UserPlaylist_.id} TEXT PRIMARY KEY NOT NULL,
        ${UserPlaylist_.createdAtMillis} INTEGER,
        ${UserPlaylist_.playlistId} TEXT,
        ${UserPlaylist_.userId} TEXT,
        ${UserPlaylist_.isSpotifySavedPlaylist} INTEGER
      );
    ''',
  );
}
