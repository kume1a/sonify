import 'package:common_models/common_models.dart';

import '../model/user_sync_datum.dart';

abstract interface class UserSyncDatumRemoteRepository {
  Future<Either<NetworkCallError, UserSyncDatum>> getAuthUserSyncDatum();

  Future<Either<NetworkCallError, Unit>> markAuthUserAudioLastUpdatedAtAsNow();
}
