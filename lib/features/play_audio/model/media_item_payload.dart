import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_payload.freezed.dart';

@freezed
class MediaItemPayload with _$MediaItemPayload {
  const factory MediaItemPayload({
    required Audio audio,
    required String? playlistId,
  }) = _MediaItemPayload;

  const MediaItemPayload._();

  factory MediaItemPayload.fromExtras(Map<String, dynamic> extras) {
    return MediaItemPayload(
      audio: Audio(
        id: extras['audio.id'],
        localId: extras['audio.localId'],
        createdAt: tryMapDateMillis(extras['audio.createdAtMillis']),
        title: extras['audio.title'],
        durationMs: extras['audio.durationMs'],
        path: extras['audio.path'],
        localPath: extras['audio.localPath'],
        author: extras['audio.author'],
        sizeBytes: extras['audio.sizeBytes'],
        youtubeVideoId: extras['audio.youtubeVideoId'],
        spotifyId: extras['audio.spotifyId'],
        thumbnailPath: extras['audio.thumbnailPath'],
        thumbnailUrl: extras['audio.thumbnailUrl'],
        localThumbnailPath: extras['audio.localThumbnailPath'],
        isLiked: extras['audio.isLiked'],
      ),
      playlistId: extras['playlistId'] as String?,
    );
  }

  Map<String, dynamic> toExtras() {
    return {
      'audio.id': audio.id,
      'audio.localId': audio.localId,
      'audio.createdAtMillis': audio.createdAt?.millisecondsSinceEpoch,
      'audio.title': audio.title,
      'audio.durationMs': audio.durationMs,
      'audio.path': audio.path,
      'audio.localPath': audio.localPath,
      'audio.author': audio.author,
      'audio.sizeBytes': audio.sizeBytes,
      'audio.youtubeVideoId': audio.youtubeVideoId,
      'audio.spotifyId': audio.spotifyId,
      'audio.thumbnailPath': audio.thumbnailPath,
      'audio.thumbnailUrl': audio.thumbnailUrl,
      'audio.localThumbnailPath': audio.localThumbnailPath,
      'audio.isLiked': audio.isLiked,
      'playlistId': playlistId,
    };
  }
}
