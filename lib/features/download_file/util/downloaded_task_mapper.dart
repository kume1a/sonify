import '../model/download_task.dart';
import '../model/downloaded_task.dart';

abstract interface class DownloadedTaskMapper {
  DownloadedTask fromDownloadTask(
    DownloadTask downloadTask,
    String? thumbnailSavePath,
  );
}
