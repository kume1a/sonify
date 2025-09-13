import 'dart:async';

import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../../../shared/util/utils.dart';
import '../../dynamic_client/api/dynamic_api_url_provider.dart';
import '../../user_preferences/api/user_preferences_store.dart';
import '../api/download_task_downloader.dart';
import '../api/on_download_task_downloaded.dart';
import '../model/downloads_event.dart';

typedef DownloadsState = List<DownloadTask>;

extension DownloadsCubitX on BuildContext {
  DownloadsCubit get downloadsCubit => read<DownloadsCubit>();
}

@injectable
class DownloadsCubit extends Cubit<List<DownloadTask>> {
  DownloadsCubit(
    this._eventBus,
    this._downloadTaskMapper,
    this._downloadTaskDownloader,
    this._onDownloadTaskDownloaded,
    this._downloadedTaskLocalRepository,
    this._authUserInfoProvider,
    this._dynamicApiUrlProvider,
    this._userPreferencesStore,
  ) : super([]) {
    _init();
  }

  final EventBus _eventBus;
  final DownloadTaskMapper _downloadTaskMapper;
  final DownloadTaskDownloader _downloadTaskDownloader;
  final OnDownloadTaskDownloaded _onDownloadTaskDownloaded;
  final DownloadedTaskLocalRepository _downloadedTaskLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final DynamicApiUrlProvider _dynamicApiUrlProvider;
  final UserPreferencesStore _userPreferencesStore;

  final List<Lock> _downloadLocks = [];
  final _stateLock = Lock();
  Timer? _timer;

  final _subscriptionComposite = SubscriptionComposite();

  Future<void> _init() async {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _downloadFromQueue(),
    );

    _subscriptionComposite.add(
      _eventBus.on<DownloadsEvent>().listen(_onDownloadsEvent),
    );

    _loadDownloadedTasks();
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _subscriptionComposite.closeAll();

    return super.close();
  }

  Future<void> _resizeDownloadLocks() async {
    final maxConcurrentDownloadCount = _userPreferencesStore.getMaxConcurrentDownloadCount();

    if (_downloadLocks.length == maxConcurrentDownloadCount) {
      return;
    }

    if (maxConcurrentDownloadCount > _downloadLocks.length) {
      for (int i = _downloadLocks.length; i < maxConcurrentDownloadCount; i++) {
        _downloadLocks.add(Lock());
      }
    } else {
      for (int i = _downloadLocks.length; i > maxConcurrentDownloadCount; i--) {
        _downloadLocks.removeLast();
      }
    }
  }

  Future<void> retryFailedDownloadTask(DownloadTask task) async {
    final reEnqueuedDownloadTask = task.whenOrNull(
      failed: (
        String id,
        Uri uri,
        String savePath,
        FileType fileType,
        DownloadTaskPayload payload,
      ) {
        return DownloadTask.idle(
          id: id,
          uri: uri,
          savePath: savePath,
          fileType: fileType,
          payload: payload,
        );
      },
    );

    if (reEnqueuedDownloadTask == null) {
      Logger.root.warning('Failed to re-enqueue download task: $task, not in failed state');
      return;
    }

    await _stateLock.synchronized(
      () {
        final newState = state.replace(
          (e) => e.id == reEnqueuedDownloadTask.id,
          (old) => reEnqueuedDownloadTask,
        );

        emit(newState);
      },
    );
  }

  Future<void> _onDownloadsEvent(DownloadsEvent event) async {
    final downloadTask = await event.when(
      enqueueUserAudio: (userAudio) => _downloadTaskMapper.userAudioToDownloadTask(
        userAudio,
        apiUrl: _dynamicApiUrlProvider.get(),
      ),
      enqueuePlaylistAudio: (playlistAudio) => _downloadTaskMapper.playlistAudioToDownloadTask(
        playlistAudio,
        apiUrl: _dynamicApiUrlProvider.get(),
      ),
    );

    if (downloadTask == null) {
      Logger.root.warning('Failed to create download task from event: $event');
      return;
    }

    await _enqueueDownloadTask(downloadTask);
  }

  Future<void> _enqueueDownloadTask(DownloadTask downloadTask) async {
    final userAudioId = downloadTask.payload.userAudio?.id;
    final playlistAudioId = downloadTask.payload.playlistAudio?.id;
    final userAudioYoutubeId = downloadTask.payload.userAudio?.audio?.youtubeVideoId;
    final playlistAudioYoutubeId = downloadTask.payload.playlistAudio?.audio?.youtubeVideoId;

    bool predicate(DownloadTask e) {
      final eUserAudioId = e.payload.userAudio?.id;
      final ePlaylistAudioId = e.payload.playlistAudio?.id;
      final eUserAudioYoutubeId = e.payload.userAudio?.audio?.youtubeVideoId;
      final ePlaylistAudioYoutubeId = e.payload.playlistAudio?.audio?.youtubeVideoId;

      return (userAudioId.notNullOrEmpty && eUserAudioId == userAudioId) ||
          (playlistAudioId.notNullOrEmpty && ePlaylistAudioId == playlistAudioId) ||
          (eUserAudioYoutubeId.notNullOrEmpty && eUserAudioYoutubeId == userAudioYoutubeId) ||
          (playlistAudioYoutubeId.notNullOrEmpty && ePlaylistAudioYoutubeId == playlistAudioYoutubeId);
    }

    final isAlreadyInQueue = state.any(predicate);

    if (isAlreadyInQueue) {
      Logger.root.info(
          'Download task with audio ID $userAudioId or $playlistAudioId or YouTube ID $userAudioYoutubeId or $playlistAudioYoutubeId is already in queue or downloading.');
      return;
    }

    await _stateLock.synchronized(() {
      final newState = List.of(state)..insert(0, downloadTask);
      emit(newState);
    });
  }

  Future<void> _downloadFromQueue() async {
    await _resizeDownloadLocks();

    final downloadLockCount = _downloadLocks.length;

    final downloadTasks = await _stateLock.synchronized(
      () => state.where((e) => e.isIdle).take(downloadLockCount).toList(),
    );

    for (final downloadLock in _downloadLocks) {
      if (downloadLock.locked) {
        continue;
      }

      if (downloadTasks.isEmpty) {
        break;
      }

      final downloadTask = downloadTasks.removeAt(0);

      downloadLock.synchronized(() => _downloadFirstFromQueue(downloadTask));
    }
  }

  Future<void> _downloadFirstFromQueue(DownloadTask downloadTask) async {
    // synchronized won't allow inProgress state before finished
    // so it should be only idle in queue here
    if (!downloadTask.isIdle) {
      return;
    }

    try {
      final downloadedTask = await _downloadTaskDownloader.download(
        downloadTask,
        onReceiveProgress: (count, total, speedInBytesPerSecond) async {
          if (total < 0) {
            return;
          }

          await _stateLock.synchronized(() {
            final newState = state.replace(
              (e) => e.id == downloadTask.id,
              (old) => DownloadTask.inProgress(
                progress: count / total,
                speedInBytesPerSecond: speedInBytesPerSecond,
                id: old.id,
                fileType: old.fileType,
                payload: old.payload,
                savePath: old.savePath,
                uri: old.uri,
              ),
            );

            emit(newState);
          });
        },
      );

      if (downloadedTask != null) {
        await _onDownloadTaskDownloaded(downloadedTask);

        await _stateLock.synchronized(() {
          final newState = state.replace(
            (e) => e.id == downloadedTask.id,
            (old) => DownloadTask.completed(
              id: old.id,
              uri: old.uri,
              savePath: old.savePath,
              fileType: old.fileType,
              payload: old.payload,
            ),
          );

          emit(newState);
        });

        return;
      }
    } catch (e) {
      Logger.root.severe('Failed to download task: $downloadTask', e);
    }

    await _stateLock.synchronized(() {
      final newState = state.replace(
        (e) => e.id == downloadTask.id,
        (old) => DownloadTask.failed(
          fileType: old.fileType,
          id: old.id,
          payload: old.payload,
          savePath: old.savePath,
          uri: old.uri,
        ),
      );

      emit(newState);
    });
  }

  Future<void> _loadDownloadedTasks() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('Failed to load downloaded tasks, authUserId is null');
      return;
    }

    final downloadedTasksRes = await _downloadedTaskLocalRepository.getAllByUserId(authUserId);

    await _stateLock.synchronized(() {
      downloadedTasksRes.ifSuccess((data) {
        final newState = List.of(state)..addAll(data);

        emit(newState);
      });
    });
  }
}
