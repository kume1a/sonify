typedef VoidCallback = void Function();
typedef VoidStringCallback = void Function(String);
typedef DoubleIntCallback = Future Function(int, int);
typedef DoubleCallback = void Function(double);

typedef RetryCallbackType = Future Function(int retryCount, int statusCode);

class DownloadTask {
  DownloadTask({
    required this.taskId,
    this.accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    this.userAgent =
        'Mozilla/5.0 (Android 7.0; Mobile; rv:54.0) Gecko/54.0 Firefox/54.0 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/603.2.4',
    this.referer = '',
    required this.url,
    required this.headers,
    required this.downloadPath,
    this.data,
  });

  factory DownloadTask.create({
    required int taskId,
    required String url,
    required String downloadPath,
    Map<String, String>? headers,
    dynamic data,
  }) {
    return DownloadTask(
      taskId: taskId,
      url: url,
      downloadPath: downloadPath,
      headers: headers ?? <String, String>{},
      data: data,
    );
  }
  final String accept;
  final String userAgent;
  final String referer;
  final String url;
  final Map<String, String> headers;
  final String downloadPath;
  final dynamic data;

  // This callback used in downloader
  DoubleCallback? sizeCallback;
  DoubleCallback? downloadCallback;
  VoidStringCallback? errorCallback;
  VoidCallback? startCallback;
  VoidCallback? completeCallback;
  RetryCallbackType? retryCallback;

  // These used in isolate downloader
  int accDownloadSize = 0;
  bool isSizeEnsued = false;
  late int taskId;
}
