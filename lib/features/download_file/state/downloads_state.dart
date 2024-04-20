import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../api/download_task_downloader.dart';
import '../api/on_download_task_downloaded.dart';
import '../model/downloads_event.dart';

part 'downloads_state.freezed.dart';

@freezed
class DownloadsState with _$DownloadsState {
  const factory DownloadsState({
    required List<DownloadTask> downloading,
    required List<DownloadedTask> downloaded,
    required List<DownloadTask> failed,
  }) = _DownloadsState;

  factory DownloadsState.initial() => const DownloadsState(
        downloading: [],
        downloaded: [],
        failed: [],
      );
}

extension DownloadsCubitX on BuildContext {
  DownloadsCubit get downloadsCubit => read<DownloadsCubit>();
}

@injectable
class DownloadsCubit extends Cubit<DownloadsState> {
  DownloadsCubit(
    this._eventBus,
    this._downloadTaskMapper,
    this._downloadTaskDownloader,
    this._onDownloadTaskDownloaded,
    this._downloadedTaskLocalRepository,
    this._authUserInfoProvider,
  ) : super(DownloadsState.initial()) {
    _init();
  }

  final _queue = Queue<DownloadTask>();

  final EventBus _eventBus;
  final DownloadTaskMapper _downloadTaskMapper;
  final DownloadTaskDownloader _downloadTaskDownloader;
  final OnDownloadTaskDownloaded _onDownloadTaskDownloaded;
  final DownloadedTaskLocalRepository _downloadedTaskLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  final _lock = Lock();
  Timer? _timer;

  final _subscriptionComposite = SubscriptionComposite();

  Future<void> _init() async {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _downloadFirstFromQueue(),
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

  Future<void> _onDownloadsEvent(DownloadsEvent event) async {
    final downloadTask = await event.when(
      enqueueUserAudio: _downloadTaskMapper.userAudioToDownloadTask,
    );

    if (downloadTask == null) {
      Logger.root.warning('Failed to create download task from event: $event');
      return;
    }

    _enqueueDownloadTask(downloadTask);
  }

  Future<void> _enqueueDownloadTask(DownloadTask downloadTask) async {
    final failedDownloadTask = state.failed.firstWhereOrNull((e) => e.id == downloadTask.id);

    if (failedDownloadTask != null) {
      final reEnqueuedDownloadTask = failedDownloadTask.copyWith(
        state: DownloadTaskState.idle,
        progress: 0,
      );

      await _lock.synchronized(() {
        _queue.add(reEnqueuedDownloadTask);

        final failed = List.of(state.failed)..remove(failedDownloadTask);

        emit(state.copyWith(downloading: List.of(_queue), failed: failed));
      });

      return;
    }

    _lock.synchronized(
      () {
        _queue.add(downloadTask);
        emit(state.copyWith(downloading: List.of(_queue)));
      },
    );
  }

  Future<void> _downloadFirstFromQueue() async {
    if (_lock.inLock) {
      return;
    }

    _lock.synchronized(() async {
      final downloadTask = _queue.firstOrNull;

      if (downloadTask == null || downloadTask.state != DownloadTaskState.idle) {
        return;
      }

      // synchronized won't allow inProgress state before finished
      // so it should be only idle in queue here
      if (downloadTask.state != DownloadTaskState.idle) {
        _queue.removeFirst();
        emit(state.copyWith(downloading: List.of(_queue)));
        return;
      }

      try {
        final downloadedTask = await _downloadTaskDownloader.download(
          downloadTask,
          onReceiveProgress: (count, total, speed) {
            if (total < 0) {
              return;
            }

            _queue
              ..removeFirst()
              ..addFirst(downloadTask.copyWith(
                progress: count / total,
                speedInKbs: speed,
                state: DownloadTaskState.inProgress,
              ));

            emit(state.copyWith(downloading: List.of(_queue)));
          },
        );

        if (downloadedTask != null) {
          await _onDownloadTaskDownloaded(downloadedTask);

          _queue.removeFirst();

          final downloaded = List.of(state.downloaded)..insert(0, downloadedTask);

          emit(state.copyWith(downloading: List.of(_queue), downloaded: downloaded));
          return;
        }
      } catch (e) {
        /* ignored */
      }

      final failedDownloadTask = downloadTask.copyWith(
        progress: 0,
        state: DownloadTaskState.failed,
      );

      _queue.removeFirst();

      final failed = List.of(state.failed)..insert(0, failedDownloadTask);

      emit(state.copyWith(downloading: List.of(_queue), failed: failed));
    });
  }

  Future<void> _loadDownloadedTasks() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('Failed to load downloaded tasks, authUserId is null');
      return;
    }

    final downloadedTasksRes = await _downloadedTaskLocalRepository.getAllByUserId(authUserId);
    downloadedTasksRes.ifSuccess((data) => emit(state.copyWith(downloaded: data)));
  }
}
