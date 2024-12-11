import 'package:common_models/common_models.dart';
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
    this._saveLocalUserAudioWithAudio,
    this._saveLocalPlaylistAudioWithAudio,
    this._eventBus,
  );

  final DownloadedTaskLocalRepository _downloadedTaskLocalRepository;
  final SaveLocalUserAudioWithAudio _saveLocalUserAudioWithAudio;
  final SaveLocalPlaylistAudioWithAudio _saveLocalPlaylistAudioWithAudio;
  final EventBus _eventBus;

  @override
  Future<void> call(DownloadTask downloadTask) async {
    return switch (downloadTask.fileType) {
      FileType.audioMp3 => _handleAudioMp3Downloaded(downloadTask),
    };
  }

  Future<void> _handleAudioMp3Downloaded(DownloadTask downloadTask) async {
    var payload = downloadTask.payload;
    if (payload.userAudio != null && payload.userAudio?.audio != null) {
      final newUserAudio = await _handleUserAudioDownloaded(downloadTask.payload.userAudio!);

      if (newUserAudio.isErr) {
        return;
      }

      payload = payload.copyWith(userAudio: newUserAudio.dataOrThrow);
    }

    if (payload.playlistAudio != null && payload.playlistAudio?.audio != null) {
      final newPlaylistAudio = await _handlePlaylistAudioDownloaded(payload.playlistAudio!);

      if (newPlaylistAudio.isErr) {
        return;
      }

      payload = payload.copyWith(playlistAudio: newPlaylistAudio.dataOrThrow);
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

  Future<Result<UserAudio>> _handleUserAudioDownloaded(UserAudio userAudio) async {
    final insertedAudio = await _saveLocalUserAudioWithAudio(userAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save userAudio, $userAudio');
      return Result.err();
    }

    _eventBus.fire(EventUserAudio.downloaded(insertedAudio.dataOrThrow));

    return insertedAudio;
  }

  Future<Result<PlaylistAudio>> _handlePlaylistAudioDownloaded(PlaylistAudio playlistAudio) async {
    final insertedAudio = await _saveLocalPlaylistAudioWithAudio(playlistAudio);
    if (insertedAudio.isErr) {
      Logger.root.warning('Failed to save playlistAudio, $playlistAudio');
      return Result.err();
    }

    _eventBus.fire(EventPlaylistAudio.downloaded(insertedAudio.dataOrThrow));

    return insertedAudio;
  }
}
