import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../feature/auth/api/auth_token_store.dart';
import '../shared/types.dart';
import 'api_client.dart';
import 'authorization_interceptor.dart';

const Duration _kTimeoutDuration = Duration(minutes: 5);

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

  static Dio createAuthenticatedDio({
    required Dio noInterceptorDio,
    required AuthTokenStore authTokenStore,
    required VoidCallback afterExit,
    required LogPrint? logPrint,
    required String apiUrl,
  }) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        contentType: 'application/json',
        connectTimeout: _kTimeoutDuration,
        sendTimeout: _kTimeoutDuration,
        receiveTimeout: _kTimeoutDuration,
      ),
    );

    dio.interceptors.add(AuthorizationInterceptor(
      authTokenStore,
      afterExit,
    ));

    if (kDebugMode && logPrint != null) {
      dio.interceptors.add(PrettyLogInterceptor(logPrint: logPrint));
    }

    return dio;
  }
}
