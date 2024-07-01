import '../../shared/wrapped.dart';
import '../playlist/playlist_entity.dart';

class UserPlaylistEntity {
  UserPlaylistEntity({
    required this.id,
    required this.createdAtMillis,
    required this.playlistId,
    required this.userId,
    required this.isSpotifySavedPlaylist,
    required this.playlist,
  });

  final String? id;
  final int? createdAtMillis;
  final String? playlistId;
  final String? userId;
  final int? isSpotifySavedPlaylist;

  final PlaylistEntity? playlist;

  UserPlaylistEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? playlistId,
    Wrapped<String?>? userId,
    Wrapped<int?>? isSpotifySavedPlaylist,
    Wrapped<PlaylistEntity?>? playlist,
  }) {
    return UserPlaylistEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      playlistId: playlistId?.value ?? this.playlistId,
      userId: userId?.value ?? this.userId,
      isSpotifySavedPlaylist: isSpotifySavedPlaylist?.value ?? this.isSpotifySavedPlaylist,
      playlist: playlist?.value ?? this.playlist,
    );
  }
}
