import 'package:dio/dio.dart' hide ProgressCallback;
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'downloader.dart';

@LazySingleton(as: Downloader)
class DioDownloader implements Downloader {
  DioDownloader(
    this._dio,
  );

  final Dio _dio;

  @override
  Future<bool> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final res = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );

      if (res.statusCode == null || res.statusCode! > 299) {
        return false;
      }

      return true;
    } catch (e) {
      Logger.root.severe(e);
    }

    return false;
  }
}
