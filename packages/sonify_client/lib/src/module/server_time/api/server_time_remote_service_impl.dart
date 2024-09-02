import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../model/server_time_dto.dart';
import 'server_time_remote_service.dart';

class ServerTimeRemoteServiceImpl with SafeHttpRequestWrap implements ServerTimeRemoteService {
  ServerTimeRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, ServerTimeDto>> getServerTime() {
    return callCatchHandleNetworkCallError(
      () => _apiClientProvider.get().getServerTime(),
    );
  }
}
