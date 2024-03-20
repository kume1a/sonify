import 'package:common_models/common_models.dart';

import '../model/audio.dart';
import '../model/download_youtube_audio_failure.dart';

abstract interface class AudioRepository {
  Future<Either<DownloadYoutubeAudioFailure, Audio>> downloadYoutubeAudio(String videoId);
}
