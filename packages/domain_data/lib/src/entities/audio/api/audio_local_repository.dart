import 'package:common_models/common_models.dart';

import '../model/audio_like.dart';
import '../model/user_audio.dart';

abstract interface class AudioLocalRepository {
  Future<Result<List<UserAudio>>> getAllByUserId(String userId);

  Future<Result<List<String>>> getAllIdsByUserId(String userId);

  Future<Result<UserAudio>> save(UserAudio audio);

  Future<Result<int>> deleteUserAudioJoinsByAudioIds(List<String> ids);

  Future<Result<bool>> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<Result<AudioLike>> createAudioLike(AudioLike audioLike);

  Future<EmptyResult> deleteAudioLikeByAudioAndUserId({
    required String userId,
    required String audioId,
  });

  Future<Result<List<AudioLike>>> getAllAudioLikesByUserId({
    required String userId,
  });

  Future<Result<AudioLike?>> getAudioLikeByUserAndAudioId({
    required String userId,
    required String audioId,
  });

  Future<EmptyResult> bulkWriteAudioLikes(List<AudioLike> audioLikes);

  Future<Result<int>> deleteAudioLikesByIds(List<String> ids);
}
