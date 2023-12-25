import 'package:injectable/injectable.dart';

import '../../../shared/util/chunked_downloader.dart' hide ProgressCallback;
import 'downloader.dart';

@LazySingleton(as: Downloader)
class HttpChunkedDownloader implements Downloader {
  @override
  Future<bool> download({
    required Uri uri,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    final downloader = ChunkedDownloader(
      url: uri.toString(),
      saveFilePath: savePath,
      onProgress: (progress, total, speed) => onReceiveProgress?.call(progress, total, speed),
    );

    await downloader.start();
    await downloader.waitDone();

    return true;
  }
}
