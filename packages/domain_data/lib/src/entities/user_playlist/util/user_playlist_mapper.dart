import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../../playlist/util/playlist_mapper.dart';
import '../model/user_playlist.dart';

class UserPlaylistMapper {
  UserPlaylistMapper(
    this._playlistMapper,
  );

  final PlaylistMapper _playlistMapper;

  UserPlaylist dtoToModel(UserPlaylistDto dto) {
    return UserPlaylist(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      userId: dto.userId ?? kInvalidId,
      playlistId: dto.playlistId ?? kInvalidId,
      isSpotifySavedPlaylist: dto.isSpotifySavedPlaylist ?? false,
      playlist: tryMap(dto.playlist, _playlistMapper.dtoToModel),
    );
  }

  UserPlaylist entityToModel(UserPlaylistEntity entity) {
    return UserPlaylist(
      id: entity.id ?? kInvalidId,
      createdAt: tryMapDateMillis(entity.createdAtMillis),
      userId: entity.userId ?? kInvalidId,
      playlistId: entity.playlistId ?? kInvalidId,
      isSpotifySavedPlaylist: entity.isSpotifySavedPlaylist == 1,
      playlist: tryMap(entity.playlist, _playlistMapper.entityToModel),
    );
  }

  UserPlaylistEntity modelToEntity(UserPlaylist model) {
    return UserPlaylistEntity(
      id: model.id,
      createdAtMillis: model.createdAt?.millisecondsSinceEpoch,
      userId: model.userId,
      playlistId: model.playlistId,
      isSpotifySavedPlaylist: model.isSpotifySavedPlaylist ? 1 : 0,
      playlist: tryMap(model.playlist, _playlistMapper.modelToEntity),
    );
  }
}
