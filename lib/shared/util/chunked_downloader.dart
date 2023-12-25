import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logging/logging.dart';

typedef ProgressCallback = void Function(int progress, int total, int speedInKbs);

typedef OnDoneCallback = void Function(File file);

typedef OnErrorCallback = void Function(dynamic error);

class ChunkedDownloader {
  ChunkedDownloader({
    required this.url,
    required this.saveFilePath,
    this.headers,
    this.chunkSize = 1024 * 100, // 100kb
    this.onProgress,
    this.onDone,
    this.onError,
    this.onCancel,
    this.onPause,
    this.onResume,
  });

  final String url;
  final String saveFilePath;
  final int chunkSize;
  final ProgressCallback? onProgress;
  final OnDoneCallback? onDone;
  final OnErrorCallback? onError;
  final Function? onCancel;
  final Function? onPause;
  final Function? onResume;

  StreamSubscription<StreamedResponse>? stream;
  ChunkedStreamReader<int>? reader;
  Map<String, String>? headers;
  int speedInKbs = 0;
  bool paused = false;
  bool done = false;

  Future<void> start() async {
    try {
      int offset = 0;
      var httpClient = http.Client();
      var request = http.Request('GET', Uri.parse(url));

      if (headers != null) {
        request.headers.addAll(headers!);
      }

      var response = httpClient.send(request);

      File file = File('$saveFilePath.tmp');

      stream = response.asStream().listen(null);

      stream?.onData((http.StreamedResponse r) async {
        // Get file size
        int fileSize = int.tryParse(r.headers['content-length'] ?? '-1') ?? -1;

        reader = ChunkedStreamReader(r.stream);

        try {
          while (true) {
            while (paused) {
              await Future.delayed(const Duration(milliseconds: 500));
            }
            // Set start time for speed calculation
            int startTime = DateTime.now().millisecondsSinceEpoch;

            // Read chunk
            final buffer = await reader!.readBytes(chunkSize);

            // Calculate speed
            int endTime = DateTime.now().millisecondsSinceEpoch;
            int timeDiff = endTime - startTime;
            if (timeDiff > 0) {
              speedInKbs = (buffer.length / timeDiff) * 1000 ~/ 1024;
            }

            offset += buffer.length;

            Logger.root.finest('Downloading ${offset ~/ 1024 ~/ 1024}MB, Speed: ${speedInKbs ~/ 1024}kb/s');

            if (onProgress != null) {
              try {
                onProgress!(offset, fileSize, speedInKbs);
              } catch (e) {
                Logger.root.severe('ChunkedDownloader error onProgress: ', e);
              }
            }

            await file.writeAsBytes(buffer, mode: FileMode.append);
            if (buffer.length != chunkSize) {
              break;
            }
          }

          await file.rename(saveFilePath);

          done = true;
          onDone?.call(file);

          Logger.root.finest('Downloaded file');
        } catch (error) {
          Logger.root.severe('ChunkedDownloader inner error: $error');
          onError?.call(error);
        } finally {
          reader?.cancel();
          stream?.cancel();
        }
      });
    } catch (error) {
      Logger.root.severe('Chunked downloader outer error: $error');
      onError?.call(error);
    }
  }

  Future<void> waitDone() async {
    while (!done) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  void stop() {
    stream?.cancel();
    reader?.cancel();
    onCancel?.call();
  }

  void pause() {
    paused = true;
    onPause?.call();
  }

  /// Resume the download
  void resume() {
    paused = false;
    onResume?.call();
  }
}
