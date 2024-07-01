import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class AppEnvironment {
  AppEnvironment._();

  static Future<void> load() async {
    const environment = kDebugMode ? 'development' : 'production';

    if (kReleaseMode) {
      await dotenv.load(mergeWith: Platform.environment);
      return;
    }

    const envFileName = './env/.env.$environment';

    Logger.root.info('Loading environment: $envFileName');

    final localEnv = await _DotEnvLoader.load('./env/.env.local');

    if (localEnv.isNotEmpty) {
      Logger.root.info('Merging env with local $localEnv');
    }

    await dotenv.load(fileName: envFileName, mergeWith: localEnv);

    Logger.root.info('loaded env ${dotenv.env}');
  }

  static String get apiUrl => dotenv.get('API_URL');

  static String get wsUrl => dotenv.get('WS_URL');

  static String get googleAuthClientIdIos => dotenv.get('GOOGLE_AUTH_CLIENT_ID_IOS');

  static String get googleAuthClientIdWeb => dotenv.get('GOOGLE_AUTH_CLIENT_ID_WEB');

  static String get spotifyClientId => dotenv.get('SPOTIFY_CLIENT_ID');
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
