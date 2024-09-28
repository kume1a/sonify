import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/playlist_audio/model/playlist_audio.dart';
import '../../../entities/user_audio/model/user_audio.dart';
import 'file_type.dart';

part 'download_task.freezed.dart';

@freezed
class DownloadTask with _$DownloadTask {
  const DownloadTask._();

  const factory DownloadTask.idle({
    required String id,
    required Uri uri,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) = _idle;

  const factory DownloadTask.inProgress({
    required String id,
    required Uri uri,
    required String savePath,
    required double progress,
    required int speedInBytesPerSecond,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) = _inProgress;

  const factory DownloadTask.failed({
    required String id,
    required Uri uri,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) = _failed;

  const factory DownloadTask.completed({
    required String id,
    required Uri uri,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) = _completed;

  factory DownloadTask.initial({
    required String id,
    required Uri uri,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) =>
      DownloadTask.idle(
        id: id,
        uri: uri,
        savePath: savePath,
        fileType: fileType,
        payload: payload,
      );

  bool get isIdle => maybeWhen(
        idle: (_, __, ___, ____, _____) => true,
        orElse: () => false,
      );

  bool get isInProgress => maybeWhen(
        inProgress: (_, __, ___, ____, _____, ______, _______) => true,
        orElse: () => false,
      );

  bool get isFailed => maybeWhen(
        failed: (_, __, ___, ____, _____) => true,
        orElse: () => false,
      );

  bool get isCompleted => maybeWhen(
        completed: (_, __, ___, ____, _____) => true,
        orElse: () => false,
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
