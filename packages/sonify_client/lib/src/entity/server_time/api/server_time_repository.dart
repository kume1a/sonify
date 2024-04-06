import 'package:common_models/common_models.dart';

import '../model/server_time.dart';

abstract interface class ServerTimeRepository {
  Future<Either<FetchFailure, ServerTime>> getServerTime();
}
