import 'package:common_models/common_models.dart';

import '../model/audio_like_dto.dart';
import '../model/download_youtube_audio_error.dart';
import '../model/upload_user_local_music_error.dart';
import '../model/upload_user_local_music_params.dart';
import '../model/user_audio_dto.dart';

abstract interface class AudioRemoteService {
  Future<Either<DownloadYoutubeAudioError, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<UploadUserLocalMusicError, UserAudioDto>> uploadUserLocalMusic(
    UploadUserLocalMusicParams params,
  );

  Future<Either<NetworkCallError, List<String>>> getAuthUserAudioIds();

  Future<Either<NetworkCallError, List<UserAudioDto>>> getAuthUserAudiosByAudioIds(List<String> audioIds);

  Future<Either<NetworkCallError, AudioLikeDto>> likeAudio({
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> unlikeAudio({
    required String audioId,
  });

  Future<Either<NetworkCallError, List<AudioLikeDto>>> getAuthUserAudioLikes({
    List<String>? ids,
  });
}
