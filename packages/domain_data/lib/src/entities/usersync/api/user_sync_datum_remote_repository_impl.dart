import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/user_sync_datum.dart';
import '../util/user_sync_datum_mapper.dart';
import 'user_sync_datum_remote_repository.dart';

class UserSyncDatumRemoteRepositoryImpl implements UserSyncDatumRemoteRepository {
  UserSyncDatumRemoteRepositoryImpl(
    this._userSyncDatumRemoteService,
    this._userSyncDatumMapper,
  );

  final UserSyncDatumRemoteService _userSyncDatumRemoteService;
  final UserSyncDatumMapper _userSyncDatumMapper;

  @override
  Future<Either<FetchFailure, UserSyncDatum>> getAuthUserSyncDatum() async {
    final res = await _userSyncDatumRemoteService.getAuthUserSyncDatum();

    return res.map(_userSyncDatumMapper.dtoToModel);
  }
}
