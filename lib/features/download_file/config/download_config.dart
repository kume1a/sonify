class DownloadConfig {
  static const int defaultChunkSizeBytes = 1024 * 512;

  static const Duration progressUpdateInterval = Duration(seconds: 2);

  static const int fileSizeCacheLimit = 500;

  static const int fileSizeCacheCleanupThreshold = 250;
}
