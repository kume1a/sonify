import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';

import '../../../app/configuration/app_environment.dart';
import '../../../app/di/register_dependencies.dart';
import '../model/server_url_origin.dart';
import '../util/server_url_origin_store.dart';

abstract interface class DynamicApiUrlProvider implements Provider<String> {}

String staticGetDynamicApiUrl() {
  final dynamicApiUrlProvider = getIt<DynamicApiUrlProvider>();

  return dynamicApiUrlProvider.get();
}

@LazySingleton(as: DynamicApiUrlProvider)
class DynamicApiUrlProviderImpl implements DynamicApiUrlProvider {
  DynamicApiUrlProviderImpl(
    this._serverUrlOriginStore,
  );

  final ServerUrlOriginStore _serverUrlOriginStore;

  @override
  String get() {
    final serverUrlOrigin = _serverUrlOriginStore.read();

    return switch (serverUrlOrigin) {
      ServerUrlOrigin.local => AppEnvironment.localApiUrl,
      ServerUrlOrigin.remote => AppEnvironment.remoteApiUrl,
    };
  }
}
