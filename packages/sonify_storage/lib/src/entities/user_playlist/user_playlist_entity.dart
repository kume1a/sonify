class UserPlaylistEntity {
  UserPlaylistEntity({
    required this.id,
    required this.bCreatedAtMillis,
    required this.bPlaylistId,
    required this.bUserId,
    required this.isSpotifySavedPlaylist,
  });

  final int? id;
  final int? bCreatedAtMillis;
  final String? bPlaylistId;
  final String? bUserId;
  final int? isSpotifySavedPlaylist;
}
