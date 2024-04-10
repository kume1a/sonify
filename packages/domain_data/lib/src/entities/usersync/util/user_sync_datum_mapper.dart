import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../model/user_sync_datum.dart';

class UserSyncDatumMapper {
  UserSyncDatum dtoToModel(UserSyncDatumDto dto) {
    return UserSyncDatum(
      id: dto.id ?? kInvalidId,
      userId: dto.userId ?? kInvalidId,
      spotifyLastSyncedAt: tryMapDate(dto.spotifyLastSyncedAt),
    );
  }
}
