import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio.freezed.dart';

@freezed
class Audio with _$Audio {
  const factory Audio({
    required String? id,
    required int? localId,
    required DateTime? createdAt,
    required String title,
    required int durationMs,
    required String path,
    required String? localPath,
    required String author,
    required int sizeBytes,
    required String? youtubeVideoId,
    required String? spotifyId,
    required String? thumbnailPath,
    required String? thumbnailUrl,
    required String? localThumbnailPath,
    required bool isLiked,
  }) = _Audio;

  const Audio._();

  bool get isLocal => localId != null;

  bool get isRemote => !isLocal;
}
