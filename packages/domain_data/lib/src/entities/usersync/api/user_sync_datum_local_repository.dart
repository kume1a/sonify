import 'package:common_models/common_models.dart';

import '../model/user_sync_datum.dart';

abstract interface class UserSyncDatumLocalRepository {
  Future<Result<UserSyncDatum?>> getAuthUserSyncDatum();

  Future<EmptyResult> writeAuthUserSyncDatum(UserSyncDatum userSyncDatum);

  Future<EmptyResult> clear();
}
