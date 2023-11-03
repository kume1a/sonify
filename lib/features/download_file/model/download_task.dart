import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String url,
    required String savePath,
    required double progress,
    required FileType fileType,
    required DownloadTaskState state,
  }) = _DownloadTask;
}
