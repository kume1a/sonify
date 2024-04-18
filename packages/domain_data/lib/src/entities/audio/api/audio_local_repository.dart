import 'package:common_models/common_models.dart';

import '../model/audio.dart';
import '../model/user_audio.dart';

abstract interface class AudioLocalRepository {
  Future<Result<List<UserAudio>>> getAllByUserId(String userId);

  Future<Result<Audio?>> getById(int id);

  Future<Result<UserAudio>> save(UserAudio audio);

  Future<Result<int>> deleteUserAudioJoinsByIds(List<int> ids);
}
