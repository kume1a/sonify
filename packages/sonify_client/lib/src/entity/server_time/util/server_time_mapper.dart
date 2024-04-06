import 'package:common_utilities/common_utilities.dart';

import '../model/server_time.dart';
import '../model/server_time_dto.dart';

class ServerTimeMapper {
  ServerTime dtoToModel(ServerTimeDto dto) {
    return ServerTime(
      time: tryMapDate(dto.time),
    );
  }
}
