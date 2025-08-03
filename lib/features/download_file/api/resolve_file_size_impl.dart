import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/di/injection_tokens.dart';
import 'resolve_file_size.dart';

@LazySingleton(as: ResolveFileSize)
class ResolveFileSizeImpl implements ResolveFileSize {
  ResolveFileSizeImpl(
    @Named(InjectionToken.noInterceptorDio) Dio dio,
  ) : _dio = dio;

  final Dio _dio;

  @override
  Future<int?> call(Uri uri) async {
    try {
      final res = await _dio.head(uri.toString()).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Logger.root.warning('File size resolution timed out for: $uri');
          throw TimeoutException('File size resolution timeout', const Duration(seconds: 10));
        },
      );

      final contentLengthHeader = res.headers.value(Headers.contentLengthHeader);

      if (contentLengthHeader == null) {
        Logger.root.fine('No content-length header for: $uri');
        return null;
      }

      final size = int.tryParse(contentLengthHeader);
      if (size == null) {
        Logger.root.warning('Invalid content-length header value: $contentLengthHeader for: $uri');
      }

      return size;
    } catch (e) {
      Logger.root.warning('Failed to resolve file size for $uri: $e');
    }

    return null;
  }
}
