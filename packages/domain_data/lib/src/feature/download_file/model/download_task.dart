import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/audio/model/user_audio.dart';
import '../../../entities/playlist_audio/model/playlist_audio.dart';
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
    required int speedInKbs,
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
        speedInKbs: 0,
        fileType: fileType,
        state: DownloadTaskState.idle,
        payload: payload,
      );
}

@freezed
class DownloadTaskPayload with _$DownloadTaskPayload {
  const factory DownloadTaskPayload({
    UserAudio? userAudio,
    PlaylistAudio? playlistAudio,
  }) = _DownloadTaskPayload;
}
