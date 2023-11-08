import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/audio/model/remote_audio_file.dart';
import 'file_type.dart';

part 'download_task.freezed.dart';

enum DownloadTaskState {
  idle,
  inProgress,
  failed,
  downloaded,
}

@freezed
class DownloadTask with _$DownloadTask {
  const factory DownloadTask({
    required Uri uri,
    required String savePath,
    required double progress,
    required FileType fileType,
    required DownloadTaskState state,
    required DownloadTaskPayload payload,
  }) = _DownloadTask;
}

@freezed
class DownloadTaskPayload with _$DownloadTaskPayload {
  const factory DownloadTaskPayload({
    RemoteAudioFile? remoteAudioFile,
  }) = _DownloadTaskPayload;
}
