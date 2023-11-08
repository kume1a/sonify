import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/download_task.dart';
import '../model/file_type.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._audioEntityDao,
  );

  final AudioEntityDao _audioEntityDao;

  @override
  Future<void> call(DownloadTask downloadTask) async {
    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        await _handleAudioMp3Downloaded(downloadTask);
        break;
      case FileType.videoMp4:
        await _handleVideoMp4Downloaded(downloadTask);
        break;
    }
  }

  Future<void> _handleAudioMp3Downloaded(DownloadTask downloadTask) async {
    final entity = AudioEntity();

    entity.path = downloadTask.savePath;

    _audioEntityDao.insert(entity);
  }

  Future<void> _handleVideoMp4Downloaded(DownloadTask downloadTask) async {
    throw Exception('Not implemented');
  }
}
