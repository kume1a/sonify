import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/server_time.dart';
import '../util/server_time_mapper.dart';
import 'server_time_repository.dart';

class ServerTimeRepositoryImpl with SafeHttpRequestWrap implements ServerTimeRepository {
  ServerTimeRepositoryImpl(
    this._apiClient,
    this._serverTimeMapper,
  );

  final ApiClient _apiClient;
  final ServerTimeMapper _serverTimeMapper;

  @override
  Future<Either<FetchFailure, ServerTime>> getServerTime() {
    return callCatchWithFetchFailure(() async {
      final res = await _apiClient.getServerTime();

      return _serverTimeMapper.dtoToModel(res);
    });
  }
}
