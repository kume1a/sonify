import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'socket_provider.dart';

class SocketProviderImpl implements SocketProvider {
  SocketProviderImpl(
    // this._authTokenStore,
    // this._validateAuthTokenUsecase,
    this._wsUrl,
  );

  // final AuthTokenStore _authTokenStore;
  // final ValidateAuthTokenUsecase _validateAuthTokenUsecase;
  final String _wsUrl;

  final Lock _lock = Lock();

  WebSocket? _socket;

  // bool _waitingForValidAccessToken = false;

  @override
  Future<WebSocket?> get socket async => _lock.synchronized(() async => _socket ??= await _tryCreateSocket());

  Future<WebSocket?> _tryCreateSocket() {
    try {
      return _createSocket();
    } catch (e, stack) {
      log('$e, $stack');
    }
    return Future.value();
  }

  Future<WebSocket?> _createSocket() async {
    // final accessToken = await _waitForValidAccessToken();

    // if (accessToken == null) {
    //   return null;
    //

    Logger.root.info('Connecting to $_wsUrl');
    return WebSocket(
      Uri.parse(_wsUrl),
      timeout: const Duration(seconds: 20),
      backoff: LinearBackoff(
        initial: const Duration(seconds: 2),
        increment: const Duration(seconds: 2),
        maximum: const Duration(seconds: 20),
      ),
    );
  }

  // Future<String?> _waitForValidAccessToken() async {
  //   _waitingForValidAccessToken = true;

  //   String? accessToken;

  //   while (true) {
  //     if (!_waitingForValidAccessToken) {
  //       return null;
  //     }

  //     accessToken = await _authTokenStore.readAccessToken();

  //     final isAccessTokenValid = await _validateAuthTokenUsecase.isAccessTokenValid(accessToken);

  //     if (isAccessTokenValid) {
  //       break;
  //     }

  //     await _delay5s();
  //   }

  //   _waitingForValidAccessToken = false;

  //   return accessToken;
  // }

  @override
  Future<void> dispose() async {
    try {
      _socket?.close();
    } catch (e, stack) {
      log('$e, $stack');
    }

    // _waitingForValidAccessToken = false;
    _socket = null;
  }

  // Future<void> _delay5s() => Future.delayed(const Duration(seconds: 5));
}
