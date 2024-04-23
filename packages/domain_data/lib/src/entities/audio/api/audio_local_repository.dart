import 'package:common_models/common_models.dart';

import '../model/user_audio.dart';

abstract interface class AudioLocalRepository {
  Future<Result<List<UserAudio>>> getAllByUserId(String userId);

  Future<Result<UserAudio>> save(UserAudio audio);

  Future<Result<int>> deleteUserAudioJoinsByIds(List<int> ids);

  Future<Result<bool>> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> like({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> unlike({
    required String userId,
    required String audioId,
  });
}
