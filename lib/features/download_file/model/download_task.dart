import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
}

@freezed
class DownloadTaskPayload with _$DownloadTaskPayload {
  const factory DownloadTaskPayload({
    UserAudio? userAudio,
  }) = _DownloadTaskPayload;
}
