part of '../isolate_downloader.dart';

enum SendPortType {
  init,
  append,
  cancel,
  terminate,
  tasksize,
}

class SendPortData {
  const SendPortData({required this.type, this.data});
  final dynamic data;
  final SendPortType type;
}

enum ReceivePortType {
  append,
  progresss,
  error,
  complete,
  retry,
}

class ReceivePortData {
  const ReceivePortData({required this.type, this.data});
  final dynamic data;
  final ReceivePortType type;
}

class IsolateDownloaderTask {
  IsolateDownloaderTask({
    required this.id,
    required this.url,
    required this.fullpath,
    required this.header,
    required this.data,
  });

  factory IsolateDownloaderTask.fromDownloadTask(int taskId, DownloadTask task) {
    var header = <String, String>{};
    header['referer'] = task.referer;
    header['accept'] = task.accept;
    header['user-agent'] = task.userAgent;
    for (var element in task.headers.entries) {
      header[element.key.toLowerCase()] = element.value;
    }
    return IsolateDownloaderTask(
      id: taskId,
      url: task.url,
      fullpath: task.downloadPath,
      header: header,
      data: task.data,
    );
  }

  factory IsolateDownloaderTask.create({
    required int id,
    required String url,
    required String fullpath,
    required dynamic data,
    Map<String, dynamic>? header,
  }) {
    header ??= <String, dynamic>{};
    return IsolateDownloaderTask(
      fullpath: fullpath,
      url: url,
      id: id,
      header: header,
      data: data,
    );
  }
  final int id;
  final String url;
  final String fullpath;
  final Map<String, dynamic> header;
  final dynamic data;

  CancelToken? cancelToken;

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'url': url,
      'fullpath': fullpath,
      'header': header,
    });
  }
}

class IsolateDownloaderOption {
  IsolateDownloaderOption({
    required this.jobCount,
    required this.maxRetryCount,
  });
  final int jobCount;
  final int maxRetryCount;
}

class IsolateDownloaderProgressProtocolUnit {
  IsolateDownloaderProgressProtocolUnit({
    required this.id,
    required this.countSize,
    required this.totalSize,
  });
  final int id;
  final int countSize;
  final int totalSize;
}

class IsolateDownloaderErrorUnit {
  IsolateDownloaderErrorUnit({
    required this.id,
    required this.error,
    required this.stackTrace,
  });
  final int id;
  final String error;
  final String stackTrace;
}

int _taskCurrentCount = 0;
int _maxTaskCount = 0;
const int _maxRetryCount = 10;
const int _retryDelay = 100;
late SendPort _sendPort;
late Queue<IsolateDownloaderTask> _dqueue;
late Map<int, IsolateDownloaderTask> _workingMap;

Future<void> _processTask(IsolateDownloaderTask task) async {
  _sendPort.send(ReceivePortData(type: ReceivePortType.append, data: task.id));

  var options = BaseOptions(
    contentType: Headers.formUrlEncodedContentType,
    validateStatus: (status) => true,
  );
  var dio = Dio(options);

  for (var kv in task.header.entries) {
    dio.options.headers[kv.key] = kv.value;
  }

  // dio.interceptors.add(DioCacheManager(
  //   CacheConfig(
  //     skipDiskCache: true,
  //     maxMemoryCacheCount: 1000,
  //   ),
  // ).interceptor as Interceptor);

  try {
    var retryCount = 0;
    var tooManyRetry = true;

    do {
      var res = await dio.download(
        task.url,
        task.fullpath,
        cancelToken: task.cancelToken,
        data: task.data,
        onReceiveProgress: (count, total) {
          _sendPort.send(
            ReceivePortData(
              type: ReceivePortType.progresss,
              data: IsolateDownloaderProgressProtocolUnit(
                id: task.id,
                countSize: count,
                totalSize: total,
              ),
            ),
          );
        },
      );

      // check download not available
      if (res.statusCode != 503) {
        // check 404 or anythings
        if (res.statusCode != 200) {
          tooManyRetry = false;
          _sendPort.send(
            ReceivePortData(
              type: ReceivePortType.error,
              data: IsolateDownloaderErrorUnit(
                id: task.id,
                error: 'Code ${res.statusCode}',
                stackTrace: '',
              ),
            ),
          );
          break;
        }

        // check download file is not empty
        var file = File(task.fullpath);
        if (await file.exists()) {
          if (await file.length() != 0) {
            tooManyRetry = false;
            _sendPort.send(
              ReceivePortData(
                type: ReceivePortType.complete,
                data: task.id,
              ),
            );
            break;
          }
          await file.delete();
        }
      }

      _sendPort.send(
        ReceivePortData(
          type: ReceivePortType.retry,
          data: {
            'id': task.id,
            'url': task.url,
            'count': retryCount,
            'code': res.statusCode,
          },
        ),
      );

      retryCount++;

      await Future.delayed(const Duration(milliseconds: _retryDelay));
    } while (retryCount < _maxRetryCount);

    if (tooManyRetry) {
      _sendPort.send(
        ReceivePortData(
          type: ReceivePortType.error,
          data: IsolateDownloaderErrorUnit(
            id: task.id,
            error: 'Too many retry',
            stackTrace: '',
          ),
        ),
      );
    }
  } catch (e, st) {
    _sendPort.send(
      ReceivePortData(
        type: ReceivePortType.error,
        data: IsolateDownloaderErrorUnit(
          id: task.id,
          error: e.toString(),
          stackTrace: st.toString(),
        ),
      ),
    );
  }
  _taskCurrentCount -= 1;
  _workingMap.remove(task.id);
  _resolveQueue();
}

void _resolveQueue() {
  if (_dqueue.isEmpty) {
    return;
  }

  if (_taskCurrentCount < _maxTaskCount) {
    _taskCurrentCount += 1;
    final itask = _dqueue.removeFirst();
    _workingMap[itask.id] = itask;
    _processTask(itask);
  }
}

void _appendTask(IsolateDownloaderTask task) {
  var token = CancelToken();
  task.cancelToken = token;
  _dqueue.add(task);
  _resolveQueue();
}

void _initIsolateDownloader(IsolateDownloaderOption option) {
  _dqueue = Queue<IsolateDownloaderTask>();
  _workingMap = <int, IsolateDownloaderTask>{};
  _maxTaskCount = option.jobCount;
}

void _cancelTask(int taskId) {
  _workingMap[taskId]?.cancelToken?.cancel();
}

/// cancel all tasks and remove dqueue
void _terminate() {
  _dqueue.clear();
  for (var element in _workingMap.entries) {
    element.value.cancelToken?.cancel();
  }
}

void _modifyTaskPoolSize(int sz) {
  _maxTaskCount = sz;
}

void _downloadIsolateRoutine(SendPort sendPort) {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  _sendPort = sendPort;

  receivePort.listen((dynamic message) async {
    if (message is SendPortData) {
      switch (message.type) {
        case SendPortType.init:
          _initIsolateDownloader(message.data as IsolateDownloaderOption);
          break;
        case SendPortType.append:
          _appendTask(message.data as IsolateDownloaderTask);
          break;
        case SendPortType.cancel:
          _cancelTask(message.data as int);
          break;
        case SendPortType.terminate:
          _terminate();
          break;
        case SendPortType.tasksize:
          _modifyTaskPoolSize(message.data as int);
          break;
      }
    }
  });
}
