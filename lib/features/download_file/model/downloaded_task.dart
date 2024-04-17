import 'package:freezed_annotation/freezed_annotation.dart';

import 'download_task.dart';
import 'file_type.dart';

part 'downloaded_task.freezed.dart';

@freezed
class DownloadedTask with _$DownloadedTask {
  const factory DownloadedTask({
    required String id,
    required String savePath,
    required FileType fileType,
    required DownloadTaskPayload payload,
  }) = _DownloadedTask;
}
