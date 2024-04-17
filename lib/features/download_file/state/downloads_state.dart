import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';

import '../api/download_task_downloader.dart';
import '../api/on_download_task_downloaded.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import '../model/downloads_event.dart';
import '../util/download_task_mapper.dart';

part 'downloads_state.freezed.dart';

typedef _DownloadTaskQueueMutation = void Function(Queue<DownloadTask> queue);

@freezed
class DownloadsState with _$DownloadsState {
  const factory DownloadsState({
    required Queue<DownloadTask> queue,
    required List<DownloadedTask> downloaded,
    required List<DownloadTask> failed,
  }) = _DownloadsState;

  factory DownloadsState.initial() => DownloadsState(
        queue: Queue(),
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
  ) : super(DownloadsState.initial()) {
    _init();
  }

  final EventBus _eventBus;
  final DownloadTaskMapper _downloadTaskMapper;
  final DownloadTaskDownloader _downloadTaskDownloader;
  final OnDownloadTaskDownloaded _onDownloadTaskDownloaded;

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
        final queue = Queue.of(state.queue)..add(reEnqueuedDownloadTask);
        final failed = List.of(state.failed)..remove(failedDownloadTask);

        emit(state.copyWith(queue: queue, failed: failed));
      });

      return;
    }

    _lock.synchronized(
      () => _mutateQueueAndEmit((queue) => queue.add(downloadTask)),
    );
  }

  Future<void> _downloadFirstFromQueue() async {
    if (_lock.inLock) {
      return;
    }

    _lock.synchronized(() async {
      final downloadTask = state.queue.firstOrNull;

      if (downloadTask == null || downloadTask.state != DownloadTaskState.idle) {
        return;
      }

      // synchronized won't allow inProgress state before finished
      // so it should be only idle in queue here
      if (downloadTask.state != DownloadTaskState.idle) {
        _mutateQueueAndEmit((queue) => queue.removeFirst());
        return;
      }

      try {
        final downloadedTask = await _downloadTaskDownloader.download(
          downloadTask,
          onReceiveProgress: (count, total, speed) {
            if (total < 0) {
              return;
            }

            _mutateQueueAndEmit((queue) => queue
              ..removeFirst()
              ..addFirst(downloadTask.copyWith(
                progress: count / total,
                speedInKbs: speed,
                state: DownloadTaskState.inProgress,
              )));
          },
        );

        if (downloadedTask != null) {
          await _onDownloadTaskDownloaded(downloadedTask);

          final queue = Queue.of(state.queue)..removeFirst();
          final downloaded = List.of(state.downloaded)..insert(0, downloadedTask);

          emit(state.copyWith(queue: queue, downloaded: downloaded));
          return;
        }
      } catch (e) {
        /* ignored */
      }

      final failedDownloadTask = downloadTask.copyWith(
        progress: 0,
        state: DownloadTaskState.failed,
      );

      final queue = Queue.of(state.queue)..removeFirst();
      final failed = List.of(state.failed)..insert(0, failedDownloadTask);

      emit(state.copyWith(queue: queue, failed: failed));
    });
  }

  void _mutateQueueAndEmit(_DownloadTaskQueueMutation mutation) {
    final queue = Queue.of(state.queue);
    mutation(queue);
    emit(state.copyWith(queue: queue));
  }
}
