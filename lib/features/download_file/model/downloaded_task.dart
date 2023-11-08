import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/audio/model/local_audio_file.dart';
import 'file_type.dart';

part 'downloaded_task.freezed.dart';

@freezed
class DownloadedTask with _$DownloadedTask {
  const factory DownloadedTask({
    required String savePath,
    required FileType fileType,
    required DownloadedTaskPayload payload,
  }) = _DownloadedTask;
}

@freezed
class DownloadedTaskPayload with _$DownloadedTaskPayload {
  const factory DownloadedTaskPayload({
    LocalAudioFile? localAudioFile,
  }) = _DownloadedTaskPayload;
}
