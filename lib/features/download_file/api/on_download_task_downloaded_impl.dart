import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/model/event_user_audio.dart';
import '../../../entities/playlist/model/event_playlist_audio.dart';
import 'on_download_task_downloaded.dart';

@LazySingleton(as: OnDownloadTaskDownloaded)
class OnDownloadTaskDownloadedImpl implements OnDownloadTaskDownloaded {
  OnDownloadTaskDownloadedImpl(
    this._downloadedTaskLocalRepository,
    this._saveUserAudioWithAudio,
    this._savePlaylistAudioWithAudio,
    this._eventBus,
  );

  final DownloadedTaskLocalRepository _downloadedTaskLocalRepository;
  final SaveUserAudioWithAudio _saveUserAudioWithAudio;
  final SavePlaylistAudioWithAudio _savePlaylistAudioWithAudio;
  final EventBus _eventBus;

  @override
  Future<void> call(DownloadedTask downloadedTask) async {
    switch (downloadedTask.fileType) {
      case FileType.audioMp3:
        return _handleAudioMp3Downloaded(downloadedTask);
    }
  }

  Future<void> _handleAudioMp3Downloaded(DownloadedTask downloadTask) async {
    var payload = downloadTask.payload;
    if (payload.userAudio != null && payload.userAudio?.audio != null) {
      final newUserAudio = await _handleUserAudioDownloaded(downloadTask.payload.userAudio!);

      payload = payload.copyWith(userAudio: newUserAudio);
    }

    if (payload.playlistAudio != null && payload.playlistAudio?.audio != null) {
      final newPlaylistAudio = await _handlePlaylistAudioDownloaded(payload.playlistAudio!);

      payload = payload.copyWith(playlistAudio: newPlaylistAudio);
    }

    final downloadedTaskRes = await _downloadedTaskLocalRepository.save(
      downloadTask.copyWith(payload: payload),
    );
    if (downloadedTaskRes.isErr) {
      Logger.root.warning('Failed to save downloadedTask, $downloadTask');
      return;
    }

    Logger.root.info('download task downloaded, $downloadTask');
  }

  Future<UserAudio?> _handleUserAudioDownloaded(UserAudio userAudio) async {
    final insertedAudio = await _saveUserAudioWithAudio.save(userAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save userAudio, $userAudio');
      return null;
    }

    _eventBus.fire(EventUserAudio.downloaded(insertedAudio.dataOrThrow));

    return insertedAudio.dataOrNull;
  }

  Future<PlaylistAudio?> _handlePlaylistAudioDownloaded(PlaylistAudio playlistAudio) async {
    final insertedAudio = await _savePlaylistAudioWithAudio.save(playlistAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save playlistAudio, $playlistAudio');
      return null;
    }

    _eventBus.fire(EventPlaylistAudio.downloaded(insertedAudio.dataOrThrow));

    return insertedAudio.dataOrNull;
  }
}
