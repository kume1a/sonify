class PlaylistAudioEntity {
  PlaylistAudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.playlistId,
    required this.audioId,
  });

  final int? id;
  final int? createdAtMillis;
  final String? playlistId;
  final String? audioId;
}
