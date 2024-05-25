import 'package:common_models/common_models.dart';

import '../model/upload_user_local_music_error.dart';
import '../model/upload_user_local_music_params.dart';
import '../model/user_audio_dto.dart';

abstract interface class AudioRemoteService {
  Future<Either<UploadUserLocalMusicError, UserAudioDto>> uploadUserLocalMusic(
    UploadUserLocalMusicParams params,
  );

  Future<Either<NetworkCallError, List<String>>> getAuthUserAudioIds();

  Future<Either<NetworkCallError, List<UserAudioDto>>> getAuthUserAudiosByAudioIds(List<String> audioIds);
}
