import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'download_task_downloader.dart';
import 'downloader.dart';
import 'resolve_file_size.dart';

@LazySingleton(as: DownloadTaskDownloader)
class DownloadTaskDownloaderImpl implements DownloadTaskDownloader {
  DownloadTaskDownloaderImpl(
    this._downloader,
    this._resolveFileSize,
    this._uuidFactory,
    this._downloadedTaskMapper,
  );

  final Downloader _downloader;
  final ResolveFileSize _resolveFileSize;
  final UuidFactory _uuidFactory;
  final DownloadedTaskMapper _downloadedTaskMapper;

  @override
  Future<DownloadedTask?> download(
    DownloadTask downloadTask, {
    ProgressCallback? onReceiveProgress,
  }) async {
    final imageUri = _resolveImageUri(downloadTask);

    final extraSize = await _resolveExtraSize([imageUri]);
    final mainFileSize = await _resolveFileSize(downloadTask.uri) ?? 0;

    final totalDownloadSize = extraSize + mainFileSize;
    var downloadedSize = 0;

    Logger.root.finer('resolved extraSize=$extraSize, mainFileSize=$mainFileSize');

    final success = await _downloader.download(
      uri: downloadTask.uri,
      savePath: downloadTask.savePath,
      onReceiveProgress: (count, total, speed) {
        downloadedSize += count;
        onReceiveProgress?.call(downloadedSize, totalDownloadSize, speed);
      },
    );

    if (!success) {
      return null;
    }

    String? thumbnailSavePath;
    if (imageUri != null) {
      final imageSaveDirectory = await ResourceSavePathProvider.getAudioMp3ImagesSavePath();
      final imageName = imageUri.pathSegments.lastOrNull ?? '${_uuidFactory.generate()}.webp';

      thumbnailSavePath = '$imageSaveDirectory/$imageName';

      await _downloader.download(
        uri: imageUri,
        savePath: thumbnailSavePath,
        onReceiveProgress: (count, total, speed) {
          downloadedSize += count;
          onReceiveProgress?.call(downloadedSize, totalDownloadSize, speed);
        },
      );
    }

    final newDownloadTask = downloadTask.copyWith(
      payload: downloadTask.payload.copyWith(
        userAudio: downloadTask.payload.userAudio?.copyWith(
          audio: downloadTask.payload.userAudio?.audio?.copyWith(
            localPath: downloadTask.savePath,
            localThumbnailPath: thumbnailSavePath,
          ),
        ),
      ),
    );

    return _downloadedTaskMapper.fromDownloadTask(newDownloadTask);
  }

  Uri? _resolveImageUri(DownloadTask downloadTask) {
    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        final audio = downloadTask.payload.userAudio?.audio;

        if (audio?.thumbnailPath != null) {
          return Uri.tryParse(assembleRemoteMediaUrl(audio!.thumbnailPath!));
        }

        if (audio?.thumbnailUrl != null) {
          return Uri.tryParse(audio!.thumbnailUrl!);
        }

        return null;
    }
  }

  Future<int> _resolveExtraSize(List<Uri?> uris) async {
    int extraSize = 0;

    for (final uri in uris) {
      if (uri == null) {
        continue;
      }

      final size = await _resolveFileSize(uri);

      if (size != null) {
        extraSize += size;
      }
    }

    return extraSize;
  }
}
