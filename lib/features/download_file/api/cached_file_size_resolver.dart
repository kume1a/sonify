import 'dart:collection';

import 'package:injectable/injectable.dart';

import '../config/download_config.dart';
import 'resolve_file_size.dart';

@LazySingleton()
class CachedFileSizeResolver {
  CachedFileSizeResolver(this._resolveFileSize);

  final ResolveFileSize _resolveFileSize;
  final Map<String, int?> _cache = HashMap<String, int?>();

  Future<int?> resolveFileSize(Uri uri) async {
    final key = uri.toString();

    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    try {
      final size = await _resolveFileSize(uri).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          return null;
        },
      );

      if (_cache.length >= DownloadConfig.fileSizeCacheLimit) {
        final keys = _cache.keys.take(DownloadConfig.fileSizeCacheCleanupThreshold).toList();
        for (final key in keys) {
          _cache.remove(key);
        }
      }

      _cache[key] = size;
      return size;
    } catch (e) {
      _cache[key] = null;
      return null;
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
