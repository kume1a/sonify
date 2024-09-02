import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import 'dynamic_ws_url_provider.dart';

@LazySingleton(as: DisposableProvider<SocketHolder>)
class DynamicSocketHolderProvider implements DisposableProvider<SocketHolder> {
  DynamicSocketHolderProvider(
    this._dynamicWsUrlProvider,
    this._authTokenStore,
    this._validateAccessToken,
  );

  final DynamicWsUrlProvider _dynamicWsUrlProvider;
  final AuthTokenStore _authTokenStore;
  final ValidateAccessToken _validateAccessToken;

  final Map<String, SocketHolder> _cache = {};

  @override
  SocketHolder get() {
    final wsUrl = _dynamicWsUrlProvider.get();

    return _cache.putIfAbsent(
      wsUrl,
      () => SocketHolderImpl(
        _authTokenStore,
        _validateAccessToken,
        wsUrl,
      ),
    );
  }

  @override
  Future<void> dispose() {
    return Future.wait(
      _cache.values.map((socketHolder) => socketHolder.dispose()),
    );
  }
}
