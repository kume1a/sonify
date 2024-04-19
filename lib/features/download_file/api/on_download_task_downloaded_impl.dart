import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/model/event_user_audio.dart';
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
        return _handleAudioMp3Downloaded(downloadedTask);
    }
  }

  Future<void> _handleAudioMp3Downloaded(DownloadedTask downloadTask) async {
    final userAudio = downloadTask.payload.userAudio;

    if (userAudio == null) {
      Logger.root.warning('UserAudio is null, $downloadTask');
      return;
    }

    Logger.root.info('UserAudio downloaded, $userAudio');

    final insertedAudio = await _audioLocalRepository.save(userAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save userAudio, $userAudio');
      return;
    }

    Logger.root.info('UserAudio saved, $insertedAudio');

    _eventBus.fire(EventUserAudio.downloaded(insertedAudio.dataOrThrow));
  }
}
