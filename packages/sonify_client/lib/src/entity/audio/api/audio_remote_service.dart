import 'package:common_models/common_models.dart';

import '../model/download_youtube_audio_failure.dart';
import '../model/user_audio_dto.dart';

abstract interface class AudioRemoteService {
  Future<Either<DownloadYoutubeAudioFailure, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  });
}
