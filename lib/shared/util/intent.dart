import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IntentLauncher {
  Future<void> launchUri(Uri uri);
}

@LazySingleton(as: IntentLauncher)
class IntentLauncherImpl implements IntentLauncher {
  @override
  Future<void> launchUri(Uri uri) {
    return _safeLaunchUri(uri);
  }

  /// @returns status indicating launch success
  Future<bool> _safeLaunchUri(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      return true;
    } catch (e) {
      Logger.root.severe(e);
    }

    return false;
  }

  // String? _encodeQueryParameters(Map<String, String> params) {
  //   return params.entries
  //       .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //       .join('&');
  // }
}
