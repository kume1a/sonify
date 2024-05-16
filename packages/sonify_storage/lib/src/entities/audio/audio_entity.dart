import '../audio_like/audio_like_entity.dart';

class AudioEntity {
  AudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.title,
    required this.durationMs,
    required this.path,
    required this.localPath,
    required this.author,
    required this.sizeBytes,
    required this.youtubeVideoId,
    required this.spotifyId,
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.localThumbnailPath,
    required this.audioLike,
  });

  final String? id;
  final int? createdAtMillis;
  final String? title;
  final int? durationMs;
  final String? path;
  final String? localPath;
  final String? author;
  final int? sizeBytes;
  final String? youtubeVideoId;
  final String? spotifyId;
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String? localThumbnailPath;

  final AudioLikeEntity? audioLike;
}
