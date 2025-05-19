import 'dart:developer';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../module/auth/api/auth_token_store.dart';
import '../usecase/validate_access_token.dart';
import 'socket_holder.dart';

class SocketHolderImpl implements SocketHolder {
  SocketHolderImpl(
    this._authTokenStore,
    this._validateAccessToken,
    this._wsUrl,
  );

  final AuthTokenStore _authTokenStore;
  final ValidateAccessToken _validateAccessToken;
  final String _wsUrl;

  final Lock _lock = Lock();

  WebSocket? _socket;

  bool _waitingForValidAccessToken = false;

  @override
  Future<WebSocket?> get socket async => _lock.synchronized(() async => _socket ??= await _tryCreateSocket());

  Future<WebSocket?> _tryCreateSocket() async {
    try {
      final websocket = await _createSocket();

      if (websocket == null) {
        Logger.root.warning('WebSocket creation failed, access token is null');
        return null;
      }

      Logger.root.fine('WebSocket created successfully');

      return websocket;
    } catch (e, stack) {
      Logger.root.info('$e, $stack');
    }

    return null;
  }

  Future<WebSocket?> _createSocket() async {
    final accessToken = await _waitForValidAccessToken();

    if (accessToken == null) {
      return null;
    }

    return WebSocket(
      Uri.parse(_wsUrl),
      timeout: const Duration(seconds: 20),
      backoff: LinearBackoff(
        initial: const Duration(seconds: 2),
        increment: const Duration(seconds: 2),
        maximum: const Duration(seconds: 20),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
  }

  Future<String?> _waitForValidAccessToken() async {
    _waitingForValidAccessToken = true;

    String? accessToken;

    while (true) {
      if (!_waitingForValidAccessToken) {
        return null;
      }

      accessToken = await _authTokenStore.readAccessToken();

      if (accessToken == null) {
        await _delay5s();
        continue;
      }

      final isAccessTokenValid = await _validateAccessToken(accessToken);

      if (isAccessTokenValid) {
        break;
      }

      await _delay5s();
    }

    _waitingForValidAccessToken = false;

    return accessToken;
  }

  @override
  Future<void> dispose() async {
    try {
      _socket?.close();
    } catch (e, stack) {
      log('$e, $stack');
    }

    _waitingForValidAccessToken = false;
    _socket = null;
  }

  Future<void> _delay5s() => Future.delayed(const Duration(seconds: 5));
}
