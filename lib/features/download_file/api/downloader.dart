typedef ProgressCallback = void Function(int count, int total);

abstract interface class Downloader {
  /// @returns [bool] indicating success
  Future<bool> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}
