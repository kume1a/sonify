import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../shared/types.dart';
import 'api_client.dart';

const Duration _kTimeoutDuration = Duration(seconds: 20);

final class NetworkClientFactory {
  static ApiClient createApiClient({
    required Dio dio,
    required String apiUrl,
  }) {
    return ApiClient(
      dio,
      baseUrl: apiUrl,
    );
  }

  static Dio createNoInterceptorDio({
    required String apiUrl,
    required LogPrint? logPrint,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        contentType: 'application/json',
        connectTimeout: _kTimeoutDuration,
        sendTimeout: _kTimeoutDuration,
        receiveTimeout: _kTimeoutDuration,
      ),
    );

    if (kDebugMode && logPrint != null) {
      dio.interceptors.add(PrettyLogInterceptor(logPrint: logPrint));
    }

    return dio;
  }
}
