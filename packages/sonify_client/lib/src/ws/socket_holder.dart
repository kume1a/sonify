import 'package:web_socket_client/web_socket_client.dart';

abstract interface class SocketHolder {
  Future<WebSocket?> get socket;

  Future<void> dispose();
}
