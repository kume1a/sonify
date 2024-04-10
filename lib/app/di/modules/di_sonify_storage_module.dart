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
  AudioEntityDao songEntityDao(Isar isar) {
    return IsarAudioEntityDao(isar);
  }
}
