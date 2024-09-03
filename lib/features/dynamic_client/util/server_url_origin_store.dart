import '../model/server_url_origin.dart';

abstract interface class ServerUrlOriginStore {
  ServerUrlOrigin read();

  Future<void> write(ServerUrlOrigin origin);
}
