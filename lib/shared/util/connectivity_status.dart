import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

@injectable
class ConnectivityStatus {
  ConnectivityStatus(
    this._connectivity,
  );

  final Connectivity _connectivity;

  StreamController<bool> connectionChangeController = StreamController.broadcast();

  Stream<bool> get connectionChange => connectionChangeController.stream;
  bool hasConnection = false;

  StreamSubscription? _sub;

  void init() {
    _sub = _connectivity.onConnectivityChanged.listen((_) => checkConnection());
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await connectionChangeController.close();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('example.com');

      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      hasConnection = false;
    } catch (e) {
      Logger.root.severe('Error checking connection: $e');
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
