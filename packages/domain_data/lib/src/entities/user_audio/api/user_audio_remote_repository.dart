import 'package:common_models/common_models.dart';

import '../../audio/model/user_audio.dart';

abstract interface class UserAudioRemoteRepository {
  Future<Either<NetworkCallError, List<UserAudio>>> createManyForAuthUser({
    required List<String> audioIds,
  });
}
