import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../util/dio_pretty_log_interceptor.dart';

const Duration _kTimeoutDuration = Duration(hours: 2);

@module
abstract class DiNetworkModule {
  @lazySingleton
  YoutubeExplode get youtubeExplode => YoutubeExplode();

  @lazySingleton
  Dio createNoInterceptorDio() {
    final dio = Dio(
      BaseOptions(
        contentType: 'application/json',
        connectTimeout: _kTimeoutDuration,
        sendTimeout: _kTimeoutDuration,
        receiveTimeout: _kTimeoutDuration,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(DioPrettyLogInterceptor(logPrint: Logger.root.fine));
    }

    return dio;
  }
}
