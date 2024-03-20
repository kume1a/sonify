import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../model/remote_audio_file.dart';

@lazySingleton
class RemoteAudioFileMapper {
  RemoteAudioFile fromAudio(Audio audio) {
    return RemoteAudioFile(
      title: audio.title,
      uri: Uri.parse(assembleResourceUrl(audio.path)),
      sizeInBytes: audio.sizeInBytes,
      author: audio.author,
      imageUri: Uri.tryParse(assembleResourceUrl(audio.thumbnailPath)),
      userId: audio.userId,
      youtubeVideoId: audio.youtubeVideoId,
      duration: Duration(seconds: audio.duration),
    );
  }
}
