import 'package:common_models/common_models.dart';

import '../model/user_sync_datum_dto.dart';

abstract interface class UserSyncDatumRemoteService {
  Future<Either<FetchFailure, UserSyncDatumDto>> getAuthUserSyncDatum();

  Future<Either<ActionFailure, Unit>> markAuthUserAudioLastUpdatedAtAsNow();
}
