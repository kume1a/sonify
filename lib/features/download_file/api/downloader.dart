typedef ProgressCallback = void Function(int count, int total, double? speed);

abstract interface class Downloader {
  /// @returns [bool] indicating success
  Future<bool> download({
    required Uri uri,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}
