import 'package:injectable/injectable.dart';

import 'package:sonify_storage/sonify_storage.dart';

@module
abstract class DiSonifyStorageModule {
  @preResolve
  @lazySingleton
  Future<Isar> isar() {
    return IsarFactory.newInstance();
  }

  // audio ---------------------------------------------------------------------
  @lazySingleton
  AudioEntityDao audioEntityDao(Isar isar) {
    return IsarAudioEntityDao(isar);
  }

  // user audio ----------------------------------------------------------------
  @lazySingleton
  UserAudioEntityDao userAudioEntityDao(Isar isar) {
    return IsarUserAudioEntityDao(isar);
  }

  @lazySingleton
  CreateUserAudioWithAudio createUserAudioWithAudio(Isar isar) {
    return IsarCreateUserAudioWithAudio(isar);
  }

  // downloaded task -----------------------------------------------------------
  @lazySingleton
  DownloadedTaskEntityDao downloadedTaskEntityDao(Isar isar) {
    return IsarDownloadedTaskEntityDao(isar);
  }
}
