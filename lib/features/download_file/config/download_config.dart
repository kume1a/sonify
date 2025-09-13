class DownloadConfig {
  static const int defaultChunkSizeBytes = 1024 * 256;

  static const Duration progressUpdateInterval = Duration(seconds: 1);

  static const int fileSizeCacheLimit = 500;

  static const int fileSizeCacheCleanupThreshold = 250;
}
