import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/audio/audio_entity.dart';
import 'entities/user_audio/user_audio_entity.dart';

abstract class IsarFactory {
  static Future<Isar> newInstance() async {
    final dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      [AudioEntitySchema, UserAudioEntitySchema],
      directory: dir.path,
      maxSizeMiB: 1024 * 10,
    );

    return isar;
  }
}
