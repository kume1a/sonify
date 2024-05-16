// ignore_for_file: camel_case_types

abstract class Audio_ {
  static const tn = 'audios';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const createdAtMillis = 'created_at_millis';
  static const title = 'title';
  static const durationMs = 'duration_ms';
  static const path = 'path';
  static const localPath = 'local_path';
  static const author = 'author';
  static const sizeBytes = 'size_bytes';
  static const youtubeVideoId = 'youtube_video_id';
  static const spotifyId = 'spotify_id';
  static const thumbnailPath = 'thumbnail_path';
  static const thumbnailUrl = 'thumbnail_url';
  static const localThumbnailPath = 'local_thumbnail_path';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedCreatedAtMillis = joinPrefixColumn(createdAtMillis);
  static final joinedTitle = joinPrefixColumn(title);
  static final joinedDurationMs = joinPrefixColumn(durationMs);
  static final joinedPath = joinPrefixColumn(path);
  static final joinedLocalPath = joinPrefixColumn(localPath);
  static final joinedAuthor = joinPrefixColumn(author);
  static final joinedSizeBytes = joinPrefixColumn(sizeBytes);
  static final joinedYoutubeVideoId = joinPrefixColumn(youtubeVideoId);
  static final joinedSpotifyId = joinPrefixColumn(spotifyId);
  static final joinedThumbnailPath = joinPrefixColumn(thumbnailPath);
  static final joinedThumbnailUrl = joinPrefixColumn(thumbnailUrl);
  static final joinedLocalThumbnailPath = joinPrefixColumn(localThumbnailPath);
}

abstract class AudioLike_ {
  static const tn = 'audio_likes';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const audioId = 'audio_id';
  static const userId = 'user_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedAudioId = joinPrefixColumn(audioId);
  static final joinedUserId = joinPrefixColumn(userId);
}

abstract class DownloadedTask_ {
  static const tn = 'downloaded_tasks';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const userId = 'user_id';
  static const taskId = 'task_id';
  static const savePath = 'save_path';
  static const fileType = 'file_type';
  static const payloadUserAudioId = 'payload_user_audio_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedUserId = joinPrefixColumn(userId);
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
  static const createdAtMillis = 'created_at_millis';
  static const userId = 'user_id';
  static const audioId = 'audio_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedCreatedAtMillis = joinPrefixColumn(createdAtMillis);
  static final joinedUserId = joinPrefixColumn(userId);
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
  static const createdAtMillis = 'created_at_millis';
  static const name = 'name';
  static const thumbnailPath = 'thumbnail_path';
  static const thumbnailUrl = 'thumbnail_url';
  static const spotifyId = 'spotify_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedCreatedAtMillis = joinPrefixColumn(createdAtMillis);
  static final joinedName = joinPrefixColumn(name);
  static final joinedThumbnailPath = joinPrefixColumn(thumbnailPath);
  static final joinedThumbnailUrl = joinPrefixColumn(thumbnailUrl);
  static final joinedSpotifyId = joinPrefixColumn(spotifyId);
}

abstract class PlaylistAudio_ {
  static const String tn = 'playlist_audios';
  static const String joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const createdAtMillis = 'created_at_millis';
  static const playlistId = 'playlist_id';
  static const audioId = 'audio_id';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedCreatedAtMillis = joinPrefixColumn(createdAtMillis);
  static final joinedPlaylistId = joinPrefixColumn(playlistId);
  static final joinedAudioId = joinPrefixColumn(audioId);
}

abstract class UserPlaylist_ {
  static const tn = 'user_playlists';
  static const joinPrefix = '${tn}_entity_';

  static String joinPrefixColumn(String column) => '$joinPrefix$column';

  static const id = 'id';
  static const createdAtMillis = 'created_at_millis';
  static const userId = 'user_id';
  static const playlistId = 'playlist_id';
  static const isSpotifySavedPlaylist = 'is_spotify_saved_playlist';

  // joined columns
  static final joinedId = joinPrefixColumn(id);
  static final joinedCreatedAtMillis = joinPrefixColumn(createdAtMillis);
  static final joinedUserId = joinPrefixColumn(userId);
  static final joinedPlaylistId = joinPrefixColumn(playlistId);
  static final joinedIsSpotifySavedPlaylist = joinPrefixColumn(isSpotifySavedPlaylist);
}
