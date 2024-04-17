import 'package:injectable/injectable.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';

@lazySingleton
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
