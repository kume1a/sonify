import '../../db/tables.dart';
import '../playlist/playlist_entity_mapper.dart';
import 'user_playlist_entity.dart';

class UserPlaylistEntityMapper {
  UserPlaylistEntityMapper(
    this._playlistEntityMapper,
  );

  final PlaylistEntityMapper _playlistEntityMapper;

  UserPlaylistEntity mapToEntity(Map<String, dynamic> m) {
    return UserPlaylistEntity(
      id: m[UserPlaylist_.id] as String?,
      createdAtMillis: m[UserPlaylist_.createdAtMillis] as int?,
      userId: m[UserPlaylist_.userId] as String?,
      playlistId: m[UserPlaylist_.playlistId] as String?,
      isSpotifySavedPlaylist: m[UserPlaylist_.isSpotifySavedPlaylist] as int?,
      playlist: _playlistEntityMapper.joinedMapToEntity(m),
    );
  }

  UserPlaylistEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[UserPlaylist_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return UserPlaylistEntity(
      id: id,
      createdAtMillis: m[UserPlaylist_.joinedCreatedAtMillis] as int?,
      userId: m[UserPlaylist_.joinedUserId] as String?,
      playlistId: m[UserPlaylist_.joinedPlaylistId] as String?,
      isSpotifySavedPlaylist: m[UserPlaylist_.joinedIsSpotifySavedPlaylist] as int?,
      playlist: _playlistEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(UserPlaylistEntity e) {
    return {
      UserPlaylist_.id: e.id,
      UserPlaylist_.createdAtMillis: e.createdAtMillis,
      UserPlaylist_.userId: e.userId,
      UserPlaylist_.playlistId: e.playlistId,
      UserPlaylist_.isSpotifySavedPlaylist: e.isSpotifySavedPlaylist,
    };
  }
}
