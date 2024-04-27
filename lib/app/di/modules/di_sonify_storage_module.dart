import 'package:injectable/injectable.dart';

import 'package:sonify_storage/sonify_storage.dart';

@module
abstract class DiSonifyStorageModule {
  @preResolve
  @lazySingleton
  Future<Database> db() {
    return DbFactory.create();
  }

  // audio like
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
  AudioEntityMapper audioEntityMapper(AudioLikeEntityMapper audioLikeEntityMapper) {
    return AudioEntityMapper(audioLikeEntityMapper);
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
}
