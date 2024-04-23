class AudioEntity {
  AudioEntity({
    required this.id,
    required this.bId,
    required this.bCreatedAtMillis,
    required this.title,
    required this.durationMs,
    required this.bPath,
    required this.localPath,
    required this.author,
    required this.sizeBytes,
    required this.youtubeVideoId,
    required this.spotifyId,
    required this.bThumbnailPath,
    required this.thumbnailUrl,
    required this.localThumbnailPath,
    this.isLiked,
  });

  final int? id;
  final String? bId;
  final int? bCreatedAtMillis;
  final String? title;
  final int? durationMs;
  final String? bPath;
  final String? localPath;
  final String? author;
  final int? sizeBytes;
  final String? youtubeVideoId;
  final String? spotifyId;
  final String? bThumbnailPath;
  final String? thumbnailUrl;
  final String? localThumbnailPath;

  // Transient
  final bool? isLiked;
}
