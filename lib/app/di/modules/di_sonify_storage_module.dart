import 'package:injectable/injectable.dart';

import 'package:sonify_storage/sonify_storage.dart';

@module
abstract class DiSonifyStorageModule {
  @preResolve
  @lazySingleton
  Future<Database> db() {
    return DbFactory.create();
  }

  @lazySingleton
  DbBatchProviderFactory dbBatchProviderFactory(Database db) {
    return SqfliteBatchProviderFactory(db);
  }

  // audio like ---------------------------------------------------------------
  @lazySingleton
  AudioLikeEntityMapper audioLikeEntityMapper() {
    return AudioLikeEntityMapper();
  }

  @lazySingleton
  AudioLikeEntityDao audioLikeEntityDao(
    Database db,
    AudioLikeEntityMapper audioLikeEntityMapper,
  ) {
    return SqfliteAudioLikeEntityDao(db, audioLikeEntityMapper);
  }

  // audio ---------------------------------------------------------------------
  @lazySingleton
  AudioEntityMapper audioEntityMapper(
    AudioLikeEntityMapper audioLikeEntityMapper,
    HiddenUserAudioEntityMapper hiddenUserAudioEntityMapper,
  ) {
    return AudioEntityMapper(
      audioLikeEntityMapper,
      hiddenUserAudioEntityMapper,
    );
  }

  @lazySingleton
  AudioEntityDao audioEntityDao(
    Database db,
    AudioEntityMapper audioEntityMapper,
  ) {
    return SqliteAudioEntityDao(db, audioEntityMapper);
  }

  // user audio ----------------------------------------------------------------
  @lazySingleton
  UserAudioEntityMapper userAudioEntityMapper(AudioEntityMapper audioEntityMapper) {
    return UserAudioEntityMapper(audioEntityMapper);
  }

  @lazySingleton
  UserAudioEntityDao userAudioEntityDao(
    Database db,
    UserAudioEntityMapper userAudioEntityMapper,
  ) {
    return SqfliteUserAudioEntityDao(db, userAudioEntityMapper);
  }

  // downloaded task -----------------------------------------------------------
  @lazySingleton
  DownloadedTaskEntityMapper downloadedTaskEntityMapper(UserAudioEntityMapper userAudioEntityMapper) {
    return DownloadedTaskEntityMapper(userAudioEntityMapper);
  }

  @lazySingleton
  DownloadedTaskEntityDao downloadedTaskEntityDao(
    Database db,
    DownloadedTaskEntityMapper downloadedTaskEntityMapper,
  ) {
    return SqfliteDownloadedTaskEntityDao(db, downloadedTaskEntityMapper);
  }

  // pending change ------------------------------------------------------------
  @lazySingleton
  PendingChangeEntityMapper pendingChangeEntityMapper() {
    return PendingChangeEntityMapper();
  }

  @lazySingleton
  PendingChangeEntityDao pendingChangeEntityDao(
    Database db,
    PendingChangeEntityMapper pendingChangeEntityMapper,
  ) {
    return SqflitePendingChangeEntityDao(db, pendingChangeEntityMapper);
  }

  // playlist ------------------------------------------------------------------
  @lazySingleton
  PlaylistEntityMapper playlistEntityMapper() {
    return PlaylistEntityMapper();
  }

  @lazySingleton
  PlaylistEntityDao playlistEntityDao(
    Database db,
    PlaylistEntityMapper playlistEntityMapper,
  ) {
    return SqflitePlaylistEntityDao(db, playlistEntityMapper);
  }

  // user playlist -------------------------------------------------------------
  @lazySingleton
  UserPlaylistEntityMapper userPlaylistEntityMapper(PlaylistEntityMapper playlistEntityMapper) {
    return UserPlaylistEntityMapper(playlistEntityMapper);
  }

  @lazySingleton
  UserPlaylistEntityDao userPlaylistEntityDao(
    Database db,
    UserPlaylistEntityMapper userPlaylistEntityMapper,
  ) {
    return SqfliteUserPlaylistEntityDao(db, userPlaylistEntityMapper);
  }

  // playlist audio ------------------------------------------------------------
  @lazySingleton
  PlaylistAudioEntityMapper playlistAudioEntityMapper(
    AudioEntityMapper audioEntityMapper,
  ) {
    return PlaylistAudioEntityMapper(
      audioEntityMapper,
    );
  }

  @lazySingleton
  PlaylistAudioEntityDao playlistAudioEntityDao(
    Database db,
    PlaylistAudioEntityMapper playlistAudioEntityMapper,
  ) {
    return SqflitePlaylistAudioEntityDao(db, playlistAudioEntityMapper);
  }
}
