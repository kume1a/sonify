import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/server_time.dart';

class ServerTimeMapper {
  ServerTime dtoToModel(ServerTimeDto dto) {
    return ServerTime(
      time: tryMapDate(dto.time),
    );
  }
}
