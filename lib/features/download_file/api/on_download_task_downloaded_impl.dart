import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/model/event_user_audio.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._audioLocalRepository,
    this._downloadedTaskLocalRepository,
    this._eventBus,
  );

  final AudioLocalRepository _audioLocalRepository;
  final DownloadedTaskLocalRepository _downloadedTaskLocalRepository;
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

    final insertedAudio = await _audioLocalRepository.save(userAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save userAudio, $userAudio');
      return;
    }

    _eventBus.fire(EventUserAudio.downloaded(insertedAudio.dataOrThrow));

    final downloadedTaskRes = await _downloadedTaskLocalRepository.save(
      downloadTask.copyWith(
        payload: downloadTask.payload.copyWith(
          userAudio: insertedAudio.dataOrThrow,
        ),
      ),
    );
    if (downloadedTaskRes.isErr) {
      Logger.root.warning('Failed to save downloadedTask, $downloadTask');
      return;
    }

    Logger.root.info('download task downloaded, $downloadTask');
  }
}
