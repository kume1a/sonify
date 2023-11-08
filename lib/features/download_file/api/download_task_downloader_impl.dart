import 'package:injectable/injectable.dart';

import '../../../entities/audio/model/local_audio_file.dart';
import '../../../shared/util/resource_save_path_provider.dart';
import '../../../shared/util/uuid_factory.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';
import 'download_task_downloader.dart';
import 'downloader.dart';
import 'file_size_resolver.dart';

@LazySingleton(as: DownloadTaskDownloader)
class DownloadTaskDownloaderImpl implements DownloadTaskDownloader {
  DownloadTaskDownloaderImpl(
    this._downloader,
    this._resolveFileSize,
    this._uuidFactory,
  );

  final Downloader _downloader;
  final ResolveFileSize _resolveFileSize;
  final UuidFactory _uuidFactory;

  @override
  Future<DownloadedTask?> download(
    DownloadTask downloadTask, {
    ProgressCallback? onReceiveProgress,
  }) async {
    final imageUri = switch (downloadTask.fileType) {
      FileType.audioMp3 => downloadTask.payload.remoteAudioFile?.imageUri,
      FileType.videoMp4 => null, // TODO add case when implementing mp4 download
    };

    final extraSize = await _resolveExtraSize([imageUri]);
    final mainFileSize = await _resolveFileSize(downloadTask.uri) ?? 0;

    final totalDownloadSize = extraSize + mainFileSize;
    var downloadedSize = 0;

    final success = await _downloader.download(
      uri: downloadTask.uri,
      savePath: downloadTask.savePath,
      onReceiveProgress: (count, total) {
        downloadedSize += count;
        onReceiveProgress?.call(downloadedSize, totalDownloadSize);
      },
    );

    if (!success) {
      return null;
    }

    String? imageSavePath;
    if (imageUri != null) {
      final imageSaveDirectory = await ResourceSavePathProvider.getAudioMp3ImagesSavePath();
      final imageFileName = _uuidFactory.generate();

      imageSavePath = '$imageSaveDirectory/$imageFileName.jpg';

      await _downloader.download(
        uri: imageUri,
        savePath: imageSavePath,
        onReceiveProgress: (count, total) {
          downloadedSize += count;
          onReceiveProgress?.call(downloadedSize, totalDownloadSize);
        },
      );
    }
    final payload = switch (downloadTask.fileType) {
      FileType.audioMp3 => DownloadedTaskPayload(
          localAudioFile: LocalAudioFile(
            id: -1,
            author: downloadTask.payload.remoteAudioFile?.author ?? '',
            imagePath: imageSavePath,
            path: downloadTask.savePath,
            sizeInKb: downloadTask.payload.remoteAudioFile?.sizeInKb ?? 0,
            title: downloadTask.payload.remoteAudioFile?.title ?? '',
          ),
        ),
      FileType.videoMp4 => const DownloadedTaskPayload(), // TODO add payload
    };

    return DownloadedTask(
      savePath: downloadTask.savePath,
      fileType: downloadTask.fileType,
      payload: payload,
    );
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
