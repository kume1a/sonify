import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/playlist_audio/model/playlist_audio.dart';
import '../../../entities/user_audio/model/user_audio.dart';
import 'file_type.dart';

part 'download_task.freezed.dart';

enum DownloadTaskState {
  idle,
  inProgress,
  failed,
}

@freezed
class DownloadTask with _$DownloadTask {
  const factory DownloadTask({
    required String id,
    required Uri uri,
    required String savePath,
    required double progress,
    required int speedInBytesPerSecond,
    required FileType fileType,
    required DownloadTaskState state,
    required DownloadTaskPayload payload,
  }) = _DownloadTask;

  factory DownloadTask.initial({
    required String id,
    required Uri uri,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) =>
      DownloadTask(
        id: id,
        uri: uri,
        savePath: savePath,
        progress: 0,
        speedInBytesPerSecond: 0,
        fileType: fileType,
        state: DownloadTaskState.idle,
        payload: payload,
      );
}

@freezed
class DownloadTaskPayload with _$DownloadTaskPayload {
  const DownloadTaskPayload._();

  const factory DownloadTaskPayload({
    UserAudio? userAudio,
    PlaylistAudio? playlistAudio,
  }) = _DownloadTaskPayload;

  bool get hasImage =>
      audioThumbnailPath != null || audioThumbnailUrl != null || audioLocalThumbnailPath != null;

  String? get audioLocalThumbnailPath =>
      userAudio?.audio?.localThumbnailPath ?? playlistAudio?.audio?.localThumbnailPath;

  String? get audioThumbnailPath => userAudio?.audio?.thumbnailPath ?? playlistAudio?.audio?.thumbnailPath;

  String? get audioThumbnailUrl => userAudio?.audio?.thumbnailUrl ?? playlistAudio?.audio?.thumbnailUrl;

  String? get audioTitle => userAudio?.audio?.title ?? playlistAudio?.audio?.title;
}
