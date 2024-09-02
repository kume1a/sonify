import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:network_info_plus/network_info_plus.dart';

abstract interface class ApiBaseUrlProvider {
  Future<String> get();
}

@LazySingleton(as: ApiBaseUrlProvider)
class ApiBaseUrlProviderImpl implements ApiBaseUrlProvider {
  ApiBaseUrlProviderImpl(
    this._networkInfo,
    this._connectivity,
  );

  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;

  @override
  Future<String> get() async {
    String baseUrl;

    Logger.root.info('Getting API base URL');

    var connectivityResult = await _connectivity.checkConnectivity();
    Logger.root.info('connectivityResult: $connectivityResult');

    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      final wifiSSID = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();

      const String homeWifiSSID = 'YourHomeSSID';
      const String homeWifiBSSID = 'YourHomeBSSID';

      Logger.root.info('wifiSSID: $wifiSSID, wifiBSSID: $wifiBSSID');

      if (wifiSSID == homeWifiSSID || wifiBSSID == homeWifiBSSID) {
        // Connected to the home router
        baseUrl = 'http://192.168.x.x:port'; // Replace with your local server IP
      } else {
        // Connected to a different router
        baseUrl = 'https://your-remote-api.com'; // Replace with your remote API URL
      }
    } else {
      // Not connected to Wi-Fi
      baseUrl = 'https://your-remote-api.com'; // Use remote API URL
    }

    return baseUrl;
  }
}
