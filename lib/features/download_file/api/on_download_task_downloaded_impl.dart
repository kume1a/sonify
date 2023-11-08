import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/downloaded_task.dart';
import '../model/file_type.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._audioEntityDao,
  );

  final AudioEntityDao _audioEntityDao;

  @override
  Future<void> call(DownloadedTask downloadedTask) async {
    switch (downloadedTask.fileType) {
      case FileType.audioMp3:
        await _handleAudioMp3Downloaded(downloadedTask);
        break;
      case FileType.videoMp4:
        await _handleVideoMp4Downloaded(downloadedTask);
        break;
    }
  }

  Future<void> _handleAudioMp3Downloaded(DownloadedTask downloadTask) async {
    final localAudioFile = downloadTask.payload.localAudioFile;

    if (localAudioFile == null) {
      return;
    }

    final entity = AudioEntity();

    entity.path = localAudioFile.path;
    entity.title = localAudioFile.title;
    entity.sizeInKb = localAudioFile.sizeInKb;
    entity.imagePath = localAudioFile.imagePath;

    _audioEntityDao.insert(entity);
  }

  Future<void> _handleVideoMp4Downloaded(DownloadedTask downloadTask) async {
    throw Exception('Not implemented');
  }
}
