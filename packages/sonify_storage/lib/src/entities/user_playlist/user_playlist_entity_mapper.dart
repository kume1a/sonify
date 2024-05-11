import '../../db/tables.dart';
import 'user_playlist_entity.dart';

class UserPlaylistEntityMapper {
  UserPlaylistEntity mapToEntity(Map<String, dynamic> m) {
    return UserPlaylistEntity(
      id: m[UserPlaylist_.id] as int?,
      bCreatedAtMillis: m[UserPlaylist_.bCreatedAtMillis] as int?,
      bUserId: m[UserPlaylist_.bUserId] as String?,
      bPlaylistId: m[UserPlaylist_.bPlaylistId] as String?,
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
      bCreatedAtMillis: m[UserPlaylist_.joinedBCreatedAtMillis] as int?,
      bUserId: m[UserPlaylist_.joinedBUserId] as String?,
      bPlaylistId: m[UserPlaylist_.joinedBPlaylistId] as String?,
      isSpotifySavedPlaylist: m[UserPlaylist_.joinedIsSpotifySavedPlaylist] as int?,
    );
  }

  Map<String, dynamic> entityToMap(UserPlaylistEntity e) {
    return {
      UserPlaylist_.id: e.id,
      UserPlaylist_.bCreatedAtMillis: e.bCreatedAtMillis,
      UserPlaylist_.bUserId: e.bUserId,
      UserPlaylist_.bPlaylistId: e.bPlaylistId,
      UserPlaylist_.isSpotifySavedPlaylist: e.isSpotifySavedPlaylist,
    };
  }
}
