import 'package:common_models/common_models.dart';

import '../model/server_time_dto.dart';

abstract interface class ServerTimeRemoteService {
  Future<Either<FetchFailure, ServerTimeDto>> getServerTime();
}
