import 'package:common_models/common_models.dart';

import '../model/user_audio_dto.dart';

abstract interface class UserAudioRemoteService {
  Future<Either<NetworkCallError, List<UserAudioDto>>> createForAuthUser({
    required List<String> audioIds,
  });

  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  });
}
