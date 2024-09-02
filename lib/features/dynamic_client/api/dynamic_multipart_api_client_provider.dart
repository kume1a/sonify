import 'package:common_utilities/common_utilities.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/di/injection_tokens.dart';
import 'dynamic_api_url_provider.dart';

@LazySingleton(as: Provider<MultipartApiClient>)
class DynamicMultipartApiClientProvider implements Provider<MultipartApiClient> {
  DynamicMultipartApiClientProvider(
    this._dynamicApiUrlProvider,
    @Named(InjectionToken.authenticatedDio) this.dio,
  );

  final DynamicApiUrlProvider _dynamicApiUrlProvider;
  final Dio dio;

  final Map<String, MultipartApiClient> _cache = {};

  @override
  MultipartApiClient get() {
    final apiUrl = _dynamicApiUrlProvider.get();

    return _cache.putIfAbsent(
      apiUrl,
      () => NetworkClientFactory.createMultipartApiClient(
        dio: dio,
        apiUrl: apiUrl,
      ),
    );
  }
}
