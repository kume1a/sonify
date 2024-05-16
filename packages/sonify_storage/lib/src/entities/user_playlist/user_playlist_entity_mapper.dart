import '../../db/tables.dart';
import 'user_playlist_entity.dart';

class UserPlaylistEntityMapper {
  UserPlaylistEntity mapToEntity(Map<String, dynamic> m) {
    return UserPlaylistEntity(
      id: m[UserPlaylist_.id] as int?,
      bCreatedAtMillis: m[UserPlaylist_.createdAtMillis] as int?,
      bUserId: m[UserPlaylist_.userId] as String?,
      bPlaylistId: m[UserPlaylist_.playlistId] as String?,
      isSpotifySavedPlaylist: m[UserPlaylist_.isSpotifySavedPlaylist] as int?,
    );
  }

  UserPlaylistEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[UserPlaylist_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return UserPlaylistEntity(
      id: id,
      bCreatedAtMillis: m[UserPlaylist_.joinedCreatedAtMillis] as int?,
      bUserId: m[UserPlaylist_.joinedUserId] as String?,
      bPlaylistId: m[UserPlaylist_.joinedPlaylistId] as String?,
      isSpotifySavedPlaylist: m[UserPlaylist_.joinedIsSpotifySavedPlaylist] as int?,
    );
  }

  Map<String, dynamic> entityToMap(UserPlaylistEntity e) {
    return {
      UserPlaylist_.id: e.id,
      UserPlaylist_.createdAtMillis: e.bCreatedAtMillis,
      UserPlaylist_.userId: e.bUserId,
      UserPlaylist_.playlistId: e.bPlaylistId,
      UserPlaylist_.isSpotifySavedPlaylist: e.isSpotifySavedPlaylist,
    };
  }
}
