import 'package:injectable/injectable.dart';

import 'package:sonify_storage/sonify_storage.dart';

@module
abstract class DiSonifyStorageModule {
  @preResolve
  @lazySingleton
  Future<Isar> isar() {
    return IsarFactory.newInstance();
  }

  @lazySingleton
  AudioEntityDao audioEntityDao(Isar isar) {
    return IsarAudioEntityDao(isar);
  }

  @lazySingleton
  UserAudioEntityDao userAudioEntityDao(Isar isar) {
    return IsarUserAudioEntityDao(isar);
  }
}
