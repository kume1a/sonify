import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/local_audio_file.dart';

@lazySingleton
class AudioEntityToLocalAudioFile {
  LocalAudioFile call(AudioEntity audioEntity) {
    return LocalAudioFile(
      id: audioEntity.id,
      title: audioEntity.title ?? '',
      author: audioEntity.author ?? '',
      imagePath: audioEntity.imagePath,
      path: audioEntity.path ?? '',
      sizeInKb: audioEntity.sizeInKb ?? 0,
    );
  }
}
