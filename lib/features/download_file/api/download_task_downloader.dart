import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import 'downloader.dart';

abstract interface class DownloadTaskDownloader {
  Future<DownloadedTask?> download(
    DownloadTask downloadTask, {
    ProgressCallback? onReceiveProgress,
  });
}
