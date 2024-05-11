import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/user_playlist.dart';

class UserPlaylistMapper {
  UserPlaylist dtoToModel(UserPlaylistDto dto) {
    return UserPlaylist(
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      playlistId: dto.playlistId ?? kInvalidId,
      isSpotifySavedPlaylist: dto.isSpotifySavedPlaylist ?? false,
    );
  }

  UserPlaylist entityToModel(UserPlaylistEntity entity) {
    return UserPlaylist(
      localId: entity.id,
      createdAt: tryMapDateMillis(entity.bCreatedAtMillis),
      userId: entity.bUserId ?? kInvalidId,
      playlistId: entity.bPlaylistId ?? kInvalidId,
      isSpotifySavedPlaylist: entity.isSpotifySavedPlaylist == 1,
    );
  }

  UserPlaylistEntity modelToEntity(UserPlaylist model) {
    return UserPlaylistEntity(
      id: model.localId,
      bCreatedAtMillis: model.createdAt?.millisecondsSinceEpoch,
      bUserId: model.userId,
      bPlaylistId: model.playlistId,
      isSpotifySavedPlaylist: model.isSpotifySavedPlaylist ? 1 : 0,
    );
  }
}
