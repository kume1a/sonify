import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/server_time.dart';
import '../util/server_time_mapper.dart';
import 'server_time_remote_repository.dart';

class ServerTimeRemoteRepositoryImpl implements ServerTimeRemoteRepository {
  ServerTimeRemoteRepositoryImpl(
    this._serverTimeRemoteService,
    this._serverTimeMapper,
  );

  final ServerTimeRemoteService _serverTimeRemoteService;
  final ServerTimeMapper _serverTimeMapper;

  @override
  Future<Either<NetworkCallError, ServerTime>> getServerTime() async {
    final res = await _serverTimeRemoteService.getServerTime();

    return res.map(_serverTimeMapper.dtoToModel);
  }
}
