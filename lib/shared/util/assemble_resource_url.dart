import '../../features/dynamic_client/api/dynamic_api_url_provider.dart';

String assembleRemoteMediaUrl(String path) {
  final apiUrl = staticGetDynamicApiUrl();

  return '$apiUrl/$path';
}

String assembleLocalFileUrl(String path) {
  return 'file://$path';
}
