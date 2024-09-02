import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class AppEnvironment {
  AppEnvironment._();

  static const String _keyHomeApiUrl = 'HOME_API_URL';
  static const String _keyRemoteApiUrl = 'REMOTE_API_URL';
  static const String _keyHomeWsUrl = 'HOME_WS_URL';
  static const String _keyRemoteWsUrl = 'REMOTE_WS_URL';
  static const String _keyGoogleAuthClientIdIos = 'GOOGLE_AUTH_CLIENT_ID_IOS';
  static const String _keyGoogleAuthClientIdWeb = 'GOOGLE_AUTH_CLIENT_ID_WEB';
  static const String _keySpotifyClientId = 'SPOTIFY_CLIENT_ID';

  static String _homeApiUrl = '';
  static String _remoteApiUrl = '';
  static String _homeWsUrl = '';
  static String _remoteWsUrl = '';
  static String _googleAuthClientIdIos = '';
  static String _googleAuthClientIdWeb = '';
  static String _spotifyClientId = '';

  static Future<void> load() async {
    if (kReleaseMode) {
      _homeApiUrl = const String.fromEnvironment(_keyHomeApiUrl);
      _remoteApiUrl = const String.fromEnvironment(_keyRemoteApiUrl);
      _homeWsUrl = const String.fromEnvironment(_keyHomeWsUrl);
      _remoteWsUrl = const String.fromEnvironment(_keyRemoteWsUrl);
      _googleAuthClientIdIos = const String.fromEnvironment(_keyGoogleAuthClientIdIos);
      _googleAuthClientIdWeb = const String.fromEnvironment(_keyGoogleAuthClientIdWeb);
      _spotifyClientId = const String.fromEnvironment(_keySpotifyClientId);

      if (_homeApiUrl.isEmpty ||
          _remoteApiUrl.isEmpty ||
          _homeWsUrl.isEmpty ||
          _remoteWsUrl.isEmpty ||
          _googleAuthClientIdIos.isEmpty ||
          _googleAuthClientIdWeb.isEmpty ||
          _spotifyClientId.isEmpty) {
        throw Exception('Missing environment variables');
      }

      return;
    }

    const environment = kDebugMode ? 'development' : 'production';

    const envFileName = './env/.env.$environment';

    Logger.root.info('Loading environment file: $envFileName');

    final localEnv = await _DotEnvLoader.load('./env/.env.local');

    if (localEnv.isNotEmpty) {
      Logger.root.info('Merging env with local $localEnv');
    }

    await dotenv.load(fileName: envFileName, mergeWith: localEnv);

    _homeApiUrl = dotenv.get(_keyHomeApiUrl);
    _remoteApiUrl = dotenv.get(_keyRemoteApiUrl);
    _homeWsUrl = dotenv.get(_keyHomeWsUrl);
    _remoteWsUrl = dotenv.get(_keyRemoteWsUrl);
    _googleAuthClientIdIos = dotenv.get(_keyGoogleAuthClientIdIos);
    _googleAuthClientIdWeb = dotenv.get(_keyGoogleAuthClientIdWeb);
    _spotifyClientId = dotenv.get(_keySpotifyClientId);
  }

  static String get homeApiUrl => _homeApiUrl;

  static String get remoteApiUrl => _remoteApiUrl;

  static String get homeWsUrl => _homeWsUrl;

  static String get remoteWsUrl => _remoteWsUrl;

  static String get googleAuthClientIdIos => _googleAuthClientIdIos;

  static String get googleAuthClientIdWeb => _googleAuthClientIdWeb;

  static String get spotifyClientId => _spotifyClientId;
}

class _DotEnvLoader {
  static Future<Map<String, String>> load(String filename) async {
    String? envString;

    try {
      envString = await rootBundle.loadString(filename);
    } catch (e) {
      Logger.root.warning('Failed to load $filename, $e');
    }

    if (envString == null || envString.isEmpty) {
      return {};
    }

    final fileLines = envString.split('\n');
    const dotEnvParser = Parser();

    return dotEnvParser.parse(fileLines);
  }
}
