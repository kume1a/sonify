import 'dart:developer';
import 'dart:io';

import 'package:common_models/common_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/configuration/app_environment.dart';
import 'app/configuration/configure_audio_components.dart';
import 'app/configuration/global_http_overrides.dart';
import 'app/configuration/init_cached_stores.dart';
import 'app/di/register_dependencies.dart';
import 'app/navigation/page_navigator.dart';

// TODO fix ChunkDownloader dispose of streams
// TODO migrate downloads to a separate isolate
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnvironment.load();

  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  GlobalNavigator.navigatorKey = navigatorKey;

  HttpOverrides.global = GlobalHttpOverrides();

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  configureAudioComponents();
  initCachedStores();

  VVOConfig.password.minLength = 6;

  runApp(const App());
}
