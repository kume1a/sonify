import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import '../feature/auth/api/auth_token_store.dart';

class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(
    this._authTokenStore,
    this._afterExit,
  );

  final AuthTokenStore _authTokenStore;
  final VoidCallback _afterExit;

  final Lock _lock = Lock();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await _authTokenStore.readAccessToken();
    if (accessToken == null) {
      return super.onRequest(options, handler);
    }

    await _lock.synchronized(() async {
      accessToken = await _authTokenStore.readAccessToken();
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    });

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized ||
        err.response?.statusCode == HttpStatus.forbidden) {
      _clearExit();
    }

    return super.onError(err, handler);
  }

  Future<void> _clearExit() async {
    await _authTokenStore.clear();
    _afterExit.call();
  }
}
