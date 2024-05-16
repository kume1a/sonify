import '../../shared/wrapped.dart';

class UserPlaylistEntity {
  UserPlaylistEntity({
    required this.id,
    required this.createdAtMillis,
    required this.playlistId,
    required this.userId,
    required this.isSpotifySavedPlaylist,
  });

  final String? id;
  final int? createdAtMillis;
  final String? playlistId;
  final String? userId;
  final int? isSpotifySavedPlaylist;

  UserPlaylistEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? playlistId,
    Wrapped<String?>? userId,
    Wrapped<int?>? isSpotifySavedPlaylist,
  }) {
    return UserPlaylistEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      playlistId: playlistId?.value ?? this.playlistId,
      userId: userId?.value ?? this.userId,
      isSpotifySavedPlaylist: isSpotifySavedPlaylist?.value ?? this.isSpotifySavedPlaylist,
    );
  }
}
