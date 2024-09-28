import 'package:domain_data/domain_data.dart';

abstract interface class OnDownloadTaskDownloaded {
  Future<void> call(DownloadTask downloadTask);
}
