import 'package:common_models/common_models.dart';

import '../model/user_audio.dart';

abstract interface class UserAudioLocalRepository {
  Future<Result<List<UserAudio>>> getAll({
    required String userId,
    String? searchQuery,
  });

  Future<Result<List<String>>> getAllAudioIdsByUserId(String userId);

  Future<Result<int>> getCountByUserId(String userId);

  Future<Result<UserAudio>> create(UserAudio userAudios);

  Future<Result<List<UserAudio>>> createMany(List<UserAudio> userAudios);

  Future<Result<int>> deleteByAudioIds(List<String> ids);

  Future<Result<UserAudio?>> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<Result<bool>> existsByUserIdAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> deleteById(String id);

  Future<EmptyResult> deleteAllByUserId(String userId);
}
