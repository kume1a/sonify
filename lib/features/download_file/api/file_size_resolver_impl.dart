import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/di/injection_tokens.dart';
import 'file_size_resolver.dart';

@LazySingleton(as: ResolveFileSize)
class ResolveFileSizeImpl implements ResolveFileSize {
  ResolveFileSizeImpl(
    @Named(InjectionToken.noInterceptorDio) Dio dio,
  ) : _dio = dio;

  final Dio _dio;

  @override
  Future<int?> call(Uri uri) async {
    try {
      final res = await _dio.head(uri.toString());

      final contentLengthHeader = res.headers.value(Headers.contentLengthHeader);

      if (contentLengthHeader == null) {
        return null;
      }

      return int.tryParse(contentLengthHeader);
    } catch (e) {
      Logger.root.severe(e);
    }

    return null;
  }
}
