import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../entities/audio/model/event_audio.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._audioLocalRepository,
    this._eventBus,
  );

  final AudioLocalRepository _audioLocalRepository;
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
    final userAudio = downloadTask.payload.userAudio;

    if (userAudio == null) {
      return;
    }

    final insertedAudio = await _audioLocalRepository.save(userAudio.audio);

    _eventBus.fire(EventAudio.downloaded(insertedAudio));
  }

  Future<void> _handleVideoMp4Downloaded(DownloadedTask downloadTask) async {
    throw Exception('Not implemented');
  }
}
