import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/user_sync_datum.dart';
import '../util/user_sync_datum_mapper.dart';
import 'user_sync_datum_repository.dart';

class UserSyncDatumRepositoryImpl with SafeHttpRequestWrap implements UserSyncDatumRepository {
  UserSyncDatumRepositoryImpl(
    this._apiClient,
    this._userSyncDatumMapper,
  );

  final ApiClient _apiClient;
  final UserSyncDatumMapper _userSyncDatumMapper;

  @override
  Future<Either<FetchFailure, UserSyncDatum>> getAuthUserSyncDatum() {
    return callCatchWithFetchFailure(() async {
      final dto = await _apiClient.getAuthUserSyncDatum();

      return _userSyncDatumMapper.dtoToModel(dto);
    });
  }
}
