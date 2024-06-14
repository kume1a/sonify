import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

typedef ProgressCallback = void Function(int progress, int total, int speedInKbs);

typedef OnDoneCallback = void Function(File file);

typedef OnErrorCallback = void Function(dynamic error);

class ChunkedDownloader {
  ChunkedDownloader({
    required this.url,
    required this.saveFilePath,
    this.headers,
    this.chunkSizeInBytes = 1024 * 100, // 100kb
    this.onProgress,
  });

  final String url;
  final String saveFilePath;
  final Map<String, String>? headers;
  final int chunkSizeInBytes;
  final ProgressCallback? onProgress;

  ChunkedStreamReader<int>? _reader;

  Future<bool> start() async {
    try {
      await _tryDownload();

      return true;
    } catch (e) {
      Logger.root.severe('Chunked downloader outer error: $e');
    } finally {
      _reader?.cancel();
    }

    return false;
  }

  Future<void> _tryDownload() async {
    int offset = 0;
    final httpClient = http.Client();
    final request = http.Request('GET', Uri.parse(url));

    if (headers != null) {
      request.headers.addAll(headers!);
    }

    final response = httpClient.send(request);

    File file = File('$saveFilePath.tmp');

    await for (final r in response.asStream()) {
      // Get file size
      int fileSize = int.tryParse(r.headers['content-length'] ?? '-1') ?? -1;

      _reader = ChunkedStreamReader(r.stream);

      while (true) {
        int startTime = DateTime.now().millisecondsSinceEpoch;
        final buffer = await _reader!.readBytes(chunkSizeInBytes);

        int endTime = DateTime.now().millisecondsSinceEpoch;
        int timeDiff = endTime - startTime;
        int speedInBytesPerSecond = 0;
        if (timeDiff > 0) {
          speedInBytesPerSecond = ((buffer.length / timeDiff) * Duration.millisecondsPerSecond).floor();
        }

        offset += buffer.length;

        Logger.root
            .finest('Downloading ${offset ~/ 1024 ~/ 1024}MB, Speed: ${speedInBytesPerSecond ~/ 1024}kb/s');

        if (onProgress != null) {
          try {
            onProgress!(offset, fileSize, speedInBytesPerSecond);
          } catch (e) {
            Logger.root.severe('ChunkedDownloader error onProgress: $e');
          }
        }

        await file.writeAsBytes(buffer, mode: FileMode.append);
        if (buffer.length != chunkSizeInBytes) {
          break;
        }
      }

      await file.rename(saveFilePath);

      Logger.root.finest('Downloaded file');
    }
  }
}
