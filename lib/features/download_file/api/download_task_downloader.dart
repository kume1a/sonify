import 'package:domain_data/domain_data.dart';

import 'downloader.dart';

abstract interface class DownloadTaskDownloader {
  Future<DownloadTask?> download(
    DownloadTask downloadTask, {
    ProgressCallback? onReceiveProgress,
  });
}
