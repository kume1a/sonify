import 'package:common_models/common_models.dart';

abstract interface class HiddenUserAudioLocalRepository {
  Future<Result<bool>> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<Result<HiddenUserAudio>> create(AudioLike audioLike);

  Future<EmptyResult> deleteByAudioAndUserId({
    required String userId,
    required String audioId,
  });

  Future<Result<List<AudioLike>>> getAllByUserId({
    required String userId,
  });

  Future<Result<AudioLike?>> getByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> bulkCreate(List<AudioLike> audioLikes);

  Future<Result<int>> deleteByIds(List<String> ids);
}
