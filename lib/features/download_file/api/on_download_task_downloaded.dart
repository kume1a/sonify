import '../model/downloaded_task.dart';

abstract interface class OnDownloadTaskDownloaded {
  Future<void> call(DownloadedTask downloadedTask);
}
