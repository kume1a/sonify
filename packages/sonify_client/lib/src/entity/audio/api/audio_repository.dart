import 'package:common_models/common_models.dart';

import '../model/download_youtube_audio_failure.dart';
import '../model/user_audio.dart';

abstract interface class AudioRepository {
  Future<Either<DownloadYoutubeAudioFailure, UserAudio>> downloadYoutubeAudio(String videoId);
}
