import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/user_sync_datum_dto.dart';
import 'user_sync_datum_remote_service.dart';

class UserSyncDatumRemoteServiceImpl with SafeHttpRequestWrap implements UserSyncDatumRemoteService {
  UserSyncDatumRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, UserSyncDatumDto>> getAuthUserSyncDatum() {
    return callCatchHandleNetworkCallError(() => _apiClient.getAuthUserSyncDatum());
  }

  @override
  Future<Either<NetworkCallError, Unit>> markAuthUserAudioLastUpdatedAtAsNow() {
    return callCatchHandleNetworkCallError(() async {
      await _apiClient.markAuthUserAudioLastUpdatedAtAsNow();

      return unit;
    });
  }
}
