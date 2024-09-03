import 'package:common_models/common_models.dart';

import '../model/user_audio.dart';

abstract interface class UserAudioRemoteRepository {
  Future<Either<NetworkCallError, List<UserAudio>>> createManyForAuthUser({
    required List<String> audioIds,
  });

  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  });
}
