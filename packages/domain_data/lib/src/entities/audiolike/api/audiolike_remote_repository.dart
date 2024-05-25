import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class AudioLikeRemoteRepository {
  Future<Either<NetworkCallError, AudioLike>> likeAudio({
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> unlikeAudio({
    required String audioId,
  });

  Future<Either<NetworkCallError, List<AudioLike>>> getAuthUserAudioLikes({
    List<String>? ids,
  });
}
