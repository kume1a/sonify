import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/server_time_dto.dart';
import 'server_time_remote_service.dart';

class ServerTimeRemoteServiceImpl with SafeHttpRequestWrap implements ServerTimeRemoteService {
  ServerTimeRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, ServerTimeDto>> getServerTime() {
    return callCatchHandleNetworkCallError(() => _apiClient.getServerTime());
  }
}
