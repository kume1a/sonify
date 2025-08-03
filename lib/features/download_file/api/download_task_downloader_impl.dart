import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../../../shared/util/formatting.dart';
import '../../../shared/util/utils.dart';
import 'cached_file_size_resolver.dart';
import 'download_task_downloader.dart';
import 'downloader.dart';

@LazySingleton(as: DownloadTaskDownloader)
class DownloadTaskDownloaderImpl implements DownloadTaskDownloader {
  DownloadTaskDownloaderImpl(
    this._downloader,
    this._cachedFileSizeResolver,
    this._uuidFactory,
  );

  final Downloader _downloader;
  final CachedFileSizeResolver _cachedFileSizeResolver;
  final UuidFactory _uuidFactory;

  @override
  Future<DownloadTask?> download(
    DownloadTask downloadTask, {
    ProgressCallback? onReceiveProgress,
  }) async {
    final imageUri = _resolveImageUri(downloadTask);

    final extraSize = await _resolveExtraSize([imageUri]);
    final mainFileSize = await _cachedFileSizeResolver.resolveFileSize(downloadTask.uri) ?? 0;

    final totalDownloadSize = extraSize + mainFileSize;
    var downloadedSize = 0;

    Logger.root.finer(
        'resolved extraSize=${formatFileSizeEn(extraSize)}, mainFileSize=${formatFileSizeEn(mainFileSize)}, totalDownloadSize=${formatFileSizeEn(totalDownloadSize)}');

    final success = await _downloader.download(
      uri: downloadTask.uri,
      savePath: downloadTask.savePath,
      onReceiveProgress: (count, total, speed) {
        downloadedSize = count;
        final actualTotal = total > 0 ? total : totalDownloadSize;
        onReceiveProgress?.call(downloadedSize, actualTotal, speed);
      },
    );

    if (!success) {
      return null;
    }

    String? thumbnailSavePath;
    if (imageUri != null) {
      final imageSaveDirectory = await ResourceSavePathProvider.getAudioMp3ImagesSavePath();

      var imageName = imageUri.pathSegments.lastOrNull ?? '${_uuidFactory.generate()}.jpg';
      if (!imageName.contains('.')) {
        imageName = '$imageName.jpg';
      }

      thumbnailSavePath = '$imageSaveDirectory/$imageName';

      final didDownloadThumbnail = await _downloader.download(
        uri: imageUri,
        savePath: thumbnailSavePath,
        onReceiveProgress: (count, total, speed) {
          downloadedSize = mainFileSize + count;
          final actualTotal = total > 0 ? (mainFileSize + total) : totalDownloadSize;
          onReceiveProgress?.call(downloadedSize, actualTotal, speed);
        },
      );

      if (!didDownloadThumbnail) {
        thumbnailSavePath = null;
      }
    }

    return downloadTask.copyWith.payload(
      userAudio: downloadTask.payload.userAudio?.copyWith.audio?.call(
        localPath: downloadTask.savePath,
        localThumbnailPath: thumbnailSavePath,
      ),
      playlistAudio: downloadTask.payload.playlistAudio?.copyWith.audio?.call(
        localPath: downloadTask.savePath,
        localThumbnailPath: thumbnailSavePath,
      ),
    );
  }

  Uri? _resolveImageUri(DownloadTask downloadTask) {
    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        final audio = downloadTask.payload.userAudio?.audio ?? downloadTask.payload.playlistAudio?.audio;

        if (audio == null) {
          return null;
        }

        if (audio.thumbnailPath.notNullOrEmpty) {
          return Uri.tryParse(assembleRemoteMediaUrl(audio.thumbnailPath!));
        }

        if (audio.thumbnailUrl.notNullOrEmpty) {
          return Uri.tryParse(audio.thumbnailUrl!);
        }

        return null;
    }
  }

  Future<int> _resolveExtraSize(List<Uri?> uris) async {
    int extraSize = 0;

    try {
      for (final uri in uris) {
        if (uri == null) {
          continue;
        }

        try {
          final size = await _cachedFileSizeResolver.resolveFileSize(uri);
          if (size != null) {
            extraSize += size;
          }
        } catch (e) {
          Logger.root.fine('Failed to resolve size for $uri: $e');
        }
      }
    } catch (e) {
      Logger.root.warning('Failed to resolve extra sizes: $e, continuing with extraSize: $extraSize');
    }

    return extraSize;
  }
}
