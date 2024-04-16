import 'package:common_models/common_models.dart';

import '../model/download_youtube_audio_failure.dart';
import '../model/upload_user_local_music_failure.dart';
import '../model/upload_user_local_music_params.dart';
import '../model/user_audio_dto.dart';

abstract interface class AudioRemoteService {
  Future<Either<DownloadYoutubeAudioFailure, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<UploadUserLocalMusicFailure, UserAudioDto>> uploadUserLocalMusic(
    UploadUserLocalMusicParams params,
  );
}
