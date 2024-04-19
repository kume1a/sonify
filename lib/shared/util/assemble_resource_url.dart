import '../../app/configuration/app_environment.dart';

String assembleRemoteMediaUrl(String path) {
  return '${AppEnvironment.apiUrl}/$path';
}

String assembleLocalFileUrl(String path) {
  return 'file://$path';
}
