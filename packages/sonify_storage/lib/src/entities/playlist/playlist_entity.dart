class PlaylistEntity {
  PlaylistEntity({
    required this.id,
    required this.createdAtMillis,
    required this.name,
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.spotifyId,
  });

  final String? id;
  final int? createdAtMillis;
  final String? name;
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String? spotifyId;
}
