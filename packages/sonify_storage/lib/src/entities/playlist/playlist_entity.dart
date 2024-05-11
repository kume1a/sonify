class PlaylistEntity {
  PlaylistEntity({
    required this.id,
    required this.bId,
    required this.bCreatedAtMillis,
    required this.name,
    required this.bThumbnailPath,
    required this.thumbnailUrl,
    required this.spotifyId,
  });

  final int? id;
  final String? bId;
  final int? bCreatedAtMillis;
  final String? name;
  final String? bThumbnailPath;
  final String? thumbnailUrl;
  final String? spotifyId;
}
