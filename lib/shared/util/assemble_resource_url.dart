import '../../app/configuration/app_environment.dart';

String assembleResourceUrl(String path) {
  return '${AppEnvironment.apiUrl}/$path';
}
