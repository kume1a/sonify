import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../model/user_sync_datum_dto.dart';
import 'user_sync_datum_remote_service.dart';

class UserSyncDatumRemoteServiceImpl with SafeHttpRequestWrap implements UserSyncDatumRemoteService {
  UserSyncDatumRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, UserSyncDatumDto>> getAuthUserSyncDatum() {
    return callCatchHandleNetworkCallError(
      () => _apiClientProvider.get().getAuthUserSyncDatum(),
    );
  }

  @override
  Future<Either<NetworkCallError, Unit>> markAuthUserAudioLastUpdatedAtAsNow() {
    return callCatchHandleNetworkCallError(() async {
      await _apiClientProvider.get().markAuthUserAudioLastUpdatedAtAsNow();

      return unit;
    });
  }
}
