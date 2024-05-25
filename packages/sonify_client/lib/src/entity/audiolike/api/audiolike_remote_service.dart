import 'package:common_models/common_models.dart';

import '../model/audio_like_dto.dart';

abstract interface class AudioLikeRemoteService {
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
