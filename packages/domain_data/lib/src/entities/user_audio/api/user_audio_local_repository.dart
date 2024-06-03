import 'package:common_models/common_models.dart';

import '../../audio/model/user_audio.dart';

abstract interface class UserAudioLocalRepository {
  Future<Result<List<UserAudio>>> getAllByUserId(String userId);

  Future<Result<List<String>>> getAllIdsByUserId(String userId);

  Future<Result<UserAudio>> save(UserAudio audio);

  Future<Result<int>> deleteByAudioIds(List<String> ids);
}
