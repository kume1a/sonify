import 'package:common_models/common_models.dart';

import '../model/hidden_user_audio.dart';

abstract interface class HiddenUserAudioRemoteRepository {
  Future<Either<NetworkCallError, HiddenUserAudio>> createForAuthUser({
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  });
}
