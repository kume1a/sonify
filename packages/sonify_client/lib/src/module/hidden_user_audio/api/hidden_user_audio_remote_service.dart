import 'package:common_models/common_models.dart';

import '../model/hidden_user_audio_dto.dart';

abstract interface class HiddenUserAudioRemoteService {
  Future<Either<NetworkCallError, HiddenUserAudioDto>> createForAuthUser({
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  });
}
