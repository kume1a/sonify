import 'package:common_models/common_models.dart';

import '../model/user_audio.dart';

abstract interface class UserAudioLocalRepository {
  Future<Result<List<UserAudio>>> getAll({
    required String userId,
    String? searchQuery,
  });

  Future<Result<List<String>>> getAllAudioIdsByUserId(String userId);

  Future<Result<UserAudio>> save(UserAudio audio);

  Future<Result<int>> deleteByAudioIds(List<String> ids);

  Future<Result<UserAudio?>> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> deleteById(String id);
}
