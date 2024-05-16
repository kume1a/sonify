import '../../shared/wrapped.dart';

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

  AudioEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? title,
    Wrapped<int?>? durationMs,
    Wrapped<String?>? path,
    Wrapped<String?>? localPath,
    Wrapped<String?>? author,
    Wrapped<int?>? sizeBytes,
    Wrapped<String?>? youtubeVideoId,
    Wrapped<String?>? spotifyId,
    Wrapped<String?>? thumbnailPath,
    Wrapped<String?>? thumbnailUrl,
    Wrapped<String?>? localThumbnailPath,
    Wrapped<AudioLikeEntity?>? audioLike,
  }) {
    return AudioEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      title: title?.value ?? this.title,
      durationMs: durationMs?.value ?? this.durationMs,
      path: path?.value ?? this.path,
      localPath: localPath?.value ?? this.localPath,
      author: author?.value ?? this.author,
      sizeBytes: sizeBytes?.value ?? this.sizeBytes,
      youtubeVideoId: youtubeVideoId?.value ?? this.youtubeVideoId,
      spotifyId: spotifyId?.value ?? this.spotifyId,
      thumbnailPath: thumbnailPath?.value ?? this.thumbnailPath,
      thumbnailUrl: thumbnailUrl?.value ?? this.thumbnailUrl,
      localThumbnailPath: localThumbnailPath?.value ?? this.localThumbnailPath,
      audioLike: audioLike?.value ?? this.audioLike,
    );
  }
}
