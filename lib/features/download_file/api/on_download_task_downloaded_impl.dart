import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';

import '../../../entities/audio/api/local_audio_file_repository.dart';
import '../../../entities/audio/model/event_local_audio_file.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._localAudioFileRepository,
    this._eventBus,
  );

  final LocalAudioFileRepository _localAudioFileRepository;
  final EventBus _eventBus;

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

    await _localAudioFileRepository.save(localAudioFile);

    _eventBus.fire(EventLocalAudioFile.downloaded(localAudioFile));
  }

  Future<void> _handleVideoMp4Downloaded(DownloadedTask downloadTask) async {
    throw Exception('Not implemented');
  }
}
