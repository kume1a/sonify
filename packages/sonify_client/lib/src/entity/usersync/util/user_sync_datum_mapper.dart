import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../model/user_sync_datum.dart';
import '../model/user_sync_datum_dto.dart';

class UserSyncDatumMapper {
  UserSyncDatum dtoToModel(UserSyncDatumDto dto) {
    return UserSyncDatum(
      id: dto.id ?? kInvalidId,
      userId: dto.userId ?? kInvalidId,
      spotifyLastSyncedAt: tryMapDate(dto.spotifyLastSyncedAt),
    );
  }
}
