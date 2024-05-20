import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

abstract class ResourceSavePathProvider {
  static const String _pathAudioMp3 = 'audioMp3';
  static const String _pathAudioMp3Images = 'audioMp3Images';

  static Future<String> getAudioMp3SavePath() {
    return _ensureApplicationDocumentsDir(_pathAudioMp3);
  }

  static Future<String> getAudioMp3ImagesSavePath() {
    return _ensureApplicationDocumentsDir(_pathAudioMp3Images);
  }

  static Future<String> _ensureApplicationDocumentsDir(String path) async {
    final applicationDocumentsDir = await getApplicationDocumentsDirectory();

    final dir = Directory(join(applicationDocumentsDir.path, path));

    await dir.create(recursive: true);

    return dir.path;
  }
}
