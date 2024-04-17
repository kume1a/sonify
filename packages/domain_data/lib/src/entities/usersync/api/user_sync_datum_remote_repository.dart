import 'package:common_models/common_models.dart';

import '../model/user_sync_datum.dart';

abstract interface class UserSyncDatumRemoteRepository {
  Future<Either<FetchFailure, UserSyncDatum>> getAuthUserSyncDatum();

  Future<Either<ActionFailure, Unit>> markAuthUserAudioLastUpdatedAtAsNow();
}
