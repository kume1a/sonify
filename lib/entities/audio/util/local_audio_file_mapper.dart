import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/values/constant.dart';
import '../model/local_audio_file.dart';

@lazySingleton
class LocalAudioFileMapper {
  LocalAudioFile fromAudioEntity(AudioEntity audioEntity) {
    return LocalAudioFile(
      id: audioEntity.id ?? kInvalidIntId,
      title: audioEntity.title ?? '',
      author: audioEntity.author ?? '',
      userId: audioEntity.userId ?? '',
      duration: Duration(seconds: audioEntity.duration ?? 0),
      sizeInBytes: audioEntity.sizeInBytes ?? 0,
      thumbnailPath: audioEntity.thumbnailPath,
      youtubeVideoId: audioEntity.youtubeVideoId ?? '',
      path: audioEntity.path ?? '',
    );
  }
}
