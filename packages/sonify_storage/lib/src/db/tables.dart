// ignore_for_file: camel_case_types

abstract class Audio_ {
  static const tn = 'audios';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const bId = 'b_id';
  static const bCreatedAtMillis = 'b_created_at_millis';
  static const title = 'title';
  static const durationMs = 'duration_ms';
  static const bPath = 'b_path';
  static const localPath = 'local_path';
  static const author = 'author';
  static const sizeBytes = 'size_bytes';
  static const youtubeVideoId = 'youtube_video_id';
  static const spotifyId = 'spotify_id';
  static const bThumbnailPath = 'b_thumbnail_path';
  static const thumbnailUrl = 'thumbnail_url';
  static const localThumbnailPath = 'local_thumbnail_path';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedBId = joinPrefixColumn(bId);
  static final joinedBCreatedAtMillis = joinPrefixColumn(bCreatedAtMillis);
  static final joinedTitle = joinPrefixColumn(title);
  static final joinedDurationMs = joinPrefixColumn(durationMs);
  static final joinedBPath = joinPrefixColumn(bPath);
  static final joinedLocalPath = joinPrefixColumn(localPath);
  static final joinedAuthor = joinPrefixColumn(author);
  static final joinedSizeBytes = joinPrefixColumn(sizeBytes);
  static final joinedYoutubeVideoId = joinPrefixColumn(youtubeVideoId);
  static final joinedSpotifyId = joinPrefixColumn(spotifyId);
  static final joinedBThumbnailPath = joinPrefixColumn(bThumbnailPath);
  static final joinedThumbnailUrl = joinPrefixColumn(thumbnailUrl);
  static final joinedLocalThumbnailPath = joinPrefixColumn(localThumbnailPath);
}

abstract class AudioLike_ {
  static const tn = 'audio_likes';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const bAudioId = 'b_audio_id';
  static const bUserId = 'b_user_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedBAudioId = joinPrefixColumn(bAudioId);
  static final joinedBUserId = joinPrefixColumn(bUserId);
}

abstract class DownloadedTask_ {
  static const tn = 'downloaded_tasks';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const bUserId = 'b_user_id';
  static const taskId = 'task_id';
  static const savePath = 'save_path';
  static const fileType = 'file_type';
  static const payloadUserAudioId = 'payload_user_audio_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedBUserId = joinPrefixColumn(bUserId);
  static final joinedTaskId = joinPrefixColumn(taskId);
  static final joinedSavePath = joinPrefixColumn(savePath);
  static final joinedFileType = joinPrefixColumn(fileType);
  static final joinedPayloadUserAudioId = joinPrefixColumn(payloadUserAudioId);
}

abstract class UserAudio_ {
  static const String tn = 'user_audios';
  static const String joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const bCreatedAtMillis = 'b_created_at_millis';
  static const bUserId = 'b_user_id';
  static const bAudioId = 'b_audio_id';
  static const audioId = 'audio_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedBCreatedAtMillis = joinPrefixColumn(bCreatedAtMillis);
  static final joinedBUserId = joinPrefixColumn(bUserId);
  static final joinedBAudioId = joinPrefixColumn(bAudioId);
  static final joinedAudioId = joinPrefixColumn(audioId);
}

abstract class PendingChange_ {
  static const tn = 'pending_changes';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const type = 'type';
  static const payloadJSON = 'payload_json';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedType = joinPrefixColumn(type);
  static final joinedPayloadJSON = joinPrefixColumn(payloadJSON);
}

abstract class Playlist_ {
  static const tn = 'playlists';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const bId = 'b_id';
  static const bCreatedAtMillis = 'b_created_at_millis';
  static const name = 'name';
  static const bThumbnailPath = 'b_thumbnail_path';
  static const thumbnailUrl = 'thumbnail_url';
  static const spotifyId = 'spotify_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedBId = joinPrefixColumn(bId);
  static final joinedBCreatedAtMillis = joinPrefixColumn(bCreatedAtMillis);
  static final joinedName = joinPrefixColumn(name);
  static final joinedBThumbnailPath = joinPrefixColumn(bThumbnailPath);
  static final joinedThumbnailUrl = joinPrefixColumn(thumbnailUrl);
  static final joinedSpotifyId = joinPrefixColumn(spotifyId);
}
