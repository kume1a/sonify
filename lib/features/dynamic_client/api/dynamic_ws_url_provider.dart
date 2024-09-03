import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';

import '../../../app/configuration/app_environment.dart';
import '../model/server_url_origin.dart';
import '../util/server_url_origin_store.dart';

abstract interface class DynamicWsUrlProvider implements Provider<String> {}

@LazySingleton(as: DynamicWsUrlProvider)
class DynamicWsUrlProviderImpl implements DynamicWsUrlProvider {
  DynamicWsUrlProviderImpl(
    this._serverUrlOriginStore,
  );

  final ServerUrlOriginStore _serverUrlOriginStore;

  @override
  String get() {
    final serverUrlOrigin = _serverUrlOriginStore.read();

    return switch (serverUrlOrigin) {
      ServerUrlOrigin.local => AppEnvironment.localWsUrl,
      ServerUrlOrigin.remote => AppEnvironment.remoteWsUrl,
    };
  }
}
