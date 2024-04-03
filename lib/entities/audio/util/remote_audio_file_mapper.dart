import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../model/remote_audio_file.dart';

@lazySingleton
class RemoteAudioFileMapper {
  RemoteAudioFile fromUserAudio(UserAudio userAudio) {
    return RemoteAudioFile(
      title: userAudio.audio.title,
      uri: Uri.parse(assembleResourceUrl(userAudio.audio.path)),
      sizeInBytes: userAudio.audio.sizeInBytes,
      author: userAudio.audio.author,
      imageUri: Uri.tryParse(assembleResourceUrl(userAudio.audio.thumbnailPath)),
      userId: userAudio.userId,
      youtubeVideoId: userAudio.audio.youtubeVideoId,
      duration: Duration(milliseconds: userAudio.audio.durationMs),
    );
  }
}
