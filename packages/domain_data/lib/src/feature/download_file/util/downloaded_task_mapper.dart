import '../model/download_task.dart';
import '../model/downloaded_task.dart';

class DownloadedTaskMapper {
  DownloadedTask fromDownloadTask(
    DownloadTask downloadTask,
  ) {
    return DownloadedTask(
      id: downloadTask.id,
      savePath: downloadTask.savePath,
      fileType: downloadTask.fileType,
      payload: downloadTask.payload,
    );
  }
}
