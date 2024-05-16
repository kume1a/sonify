import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/user_playlist.dart';

class UserPlaylistMapper {
  UserPlaylist dtoToModel(UserPlaylistDto dto) {
    return UserPlaylist(
      id: dto.id,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      playlistId: dto.playlistId ?? kInvalidId,
      isSpotifySavedPlaylist: dto.isSpotifySavedPlaylist ?? false,
    );
  }

  UserPlaylist entityToModel(UserPlaylistEntity entity) {
    return UserPlaylist(
      id: entity.id,
      createdAt: tryMapDateMillis(entity.createdAtMillis),
      userId: entity.userId ?? kInvalidId,
      playlistId: entity.playlistId ?? kInvalidId,
      isSpotifySavedPlaylist: entity.isSpotifySavedPlaylist == 1,
    );
  }

  UserPlaylistEntity modelToEntity(UserPlaylist model) {
    return UserPlaylistEntity(
      id: model.id,
      createdAtMillis: model.createdAt?.millisecondsSinceEpoch,
      userId: model.userId,
      playlistId: model.playlistId,
      isSpotifySavedPlaylist: model.isSpotifySavedPlaylist ? 1 : 0,
    );
  }
}
