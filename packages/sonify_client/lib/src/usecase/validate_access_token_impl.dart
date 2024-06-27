import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'validate_access_token.dart';

class ValidateAccessTokenImpl implements ValidateAccessToken {
  ValidateAccessTokenImpl(
    this._dio,
    this._baseUrl,
  );

  final Dio _dio;
  final String _baseUrl;

  @override
  Future<bool> call(String accessToken) async {
    try {
      final res = await _dio.get(
        '$_baseUrl/auth/status',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        ),
      );

      if (res.data == null || res.data is! Map<String, dynamic>) {
        return false;
      }

      final dataJson = res.data as Map<String, dynamic>;

      return dataJson['ok'] as bool? ?? false;
    } catch (e) {
      Logger.root.info('Error validating access token: $e');
    }

    return false;
  }
}
