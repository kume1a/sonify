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
    final audioLikeId = extras['audio.audioLike.id'] as String?;
    final audioLikeAudioId = extras['audio.audioLike.audioId'] as String?;
    final audioLikeUserId = extras['audio.audioLike.userId'] as String?;

    final hiddenUserAudioId = extras['audio.hiddenUserAudio.id'] as String?;
    final hiddenUserAudioCreatedAtMillis = extras['audio.hiddenUserAudio.createdAtMillis'] as int?;
    final hiddenUserAudioUserId = extras['audio.hiddenUserAudio.userId'] as String?;
    final hiddenUserAudioAudioId = extras['audio.hiddenUserAudio.audioId'] as String?;

    final audioLike = audioLikeId != null && audioLikeAudioId != null && audioLikeUserId != null
        ? AudioLike(
            id: audioLikeId,
            audioId: audioLikeAudioId,
            userId: audioLikeUserId,
          )
        : null;

    final hiddenUserAudio = hiddenUserAudioId != null &&
            hiddenUserAudioCreatedAtMillis != null &&
            hiddenUserAudioUserId != null &&
            hiddenUserAudioAudioId != null
        ? HiddenUserAudio(
            id: hiddenUserAudioId,
            createdAt: tryMapDateMillis(hiddenUserAudioCreatedAtMillis),
            userId: hiddenUserAudioUserId,
            audioId: hiddenUserAudioAudioId,
          )
        : null;

    return MediaItemPayload(
      audio: Audio(
        id: extras['audio.id'],
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
        audioLike: audioLike,
        hiddenUserAudio: hiddenUserAudio,
      ),
      playlistId: extras['playlistId'] as String?,
    );
  }

  Map<String, dynamic> toExtras() {
    return {
      'audio.id': audio.id,
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
      'audio.audioLike.audioId': audio.audioLike?.audioId,
      'audio.audioLike.userId': audio.audioLike?.userId,
      'audio.audioLike.id': audio.audioLike?.id,
      'playlistId': playlistId,
    };
  }
}
