class PlaylistAudioEntity {
  PlaylistAudioEntity({
    required this.id,
    required this.bCreatedAtMillis,
    required this.bPlaylistId,
    required this.bAudioId,
  });

  final int? id;
  final int? bCreatedAtMillis;
  final String? bPlaylistId;
  final String? bAudioId;
}
