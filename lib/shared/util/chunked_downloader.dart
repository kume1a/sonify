import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../features/download_file/config/download_config.dart';

typedef ProgressCallback = void Function(int progress, int total, int speedInKbs);

typedef OnDoneCallback = void Function(File file);

typedef OnErrorCallback = void Function(dynamic error);

class ChunkedDownloader {
  ChunkedDownloader({
    required this.url,
    required this.saveFilePath,
    this.headers,
    this.chunkSizeInBytes = DownloadConfig.defaultChunkSizeBytes,
    this.onProgress,
    this.progressInterval = DownloadConfig.progressUpdateInterval,
  });

  final String url;
  final String saveFilePath;
  final Map<String, String>? headers;
  final int chunkSizeInBytes;
  final ProgressCallback? onProgress;
  final Duration progressInterval;

  ChunkedStreamReader<int>? _reader;
  IOSink? _fileSink;

  Future<bool> start() async {
    try {
      await _tryDownload();

      return true;
    } catch (e) {
      Logger.root.severe('Chunked downloader outer error: $e');
    } finally {
      _reader?.cancel();
      await _fileSink?.flush();
      await _fileSink?.close();
    }

    return false;
  }

  Future<void> _tryDownload() async {
    int offset = 0;
    final httpClient = http.Client();

    try {
      final request = http.Request('GET', Uri.parse(url));

      if (headers != null) {
        request.headers.addAll(headers!);
      }

      final response = httpClient.send(request);

      int lastProgressTime = DateTime.now().millisecondsSinceEpoch;

      await for (final r in response.asStream()) {
        int fileSize = int.tryParse(r.headers['content-length'] ?? '-1') ?? -1;

        _reader = ChunkedStreamReader(r.stream);

        final file = File('$saveFilePath.tmp');
        _fileSink = file.openWrite();

        while (true) {
          int startTime = DateTime.now().millisecondsSinceEpoch;
          final buffer = await _reader!.readBytes(chunkSizeInBytes);

          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int timeDiff = currentTime - startTime;
          int speedInBytesPerSecond = 0;
          if (timeDiff > 0) {
            speedInBytesPerSecond = ((buffer.length / timeDiff) * Duration.millisecondsPerSecond).floor();
          }

          offset += buffer.length;

          final timeToNotify = currentTime - lastProgressTime >= progressInterval.inMilliseconds;
          if (onProgress != null && (timeToNotify || offset >= fileSize)) {
            try {
              onProgress!(offset, fileSize, speedInBytesPerSecond);
            } catch (e) {
              Logger.root.severe('ChunkedDownloader error onProgress: $e');
            }

            lastProgressTime = currentTime;
          }

          _fileSink!.add(buffer);
          if (buffer.length != chunkSizeInBytes) {
            break;
          }
        }

        await _fileSink!.flush();
        await _fileSink!.close();
        _fileSink = null;

        await file.rename(saveFilePath);
      }
    } finally {
      httpClient.close();
    }
  }
}
