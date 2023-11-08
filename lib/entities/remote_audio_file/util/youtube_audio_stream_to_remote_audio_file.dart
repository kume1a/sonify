import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/remote_audio_file.dart';

@lazySingleton
class YoutubeAudioStreamToRemoteAudioFile {
  RemoteAudioFile call(AudioOnlyStreamInfo t, Video video) {
    return RemoteAudioFile(
      title: video.title,
      uri: t.url,
      sizeInKb: t.size.totalKiloBytes.toInt(),
      author: video.author,
    );
  }
}
