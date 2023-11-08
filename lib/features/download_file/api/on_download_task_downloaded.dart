import '../model/download_task.dart';

abstract interface class OnDownloadTaskDownloaded {
  Future<void> call(DownloadTask downloadTask);
}
