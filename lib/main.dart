import 'dart:developer';

import 'package:common_models/common_models.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/configuration/app_environment.dart';
import 'app/configuration/before_app_start.dart';
import 'app/configuration/global_http_overrides.dart';
import 'app/di/register_dependencies.dart';
import 'app/navigation/page_navigator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AppEnvironment.load();

  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);
  GlobalNavigator.navigatorKey = navigatorKey;

  GlobalHttpOverrides.configure();

  VVOConfig.password.minLength = 6;

  Logger.root.level = kDebugMode ? Level.ALL : Level.OFF;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');

    FirebaseAnalytics.instance.logEvent(name: 'log', parameters: {
      'level': record.level.name,
      'time': record.time.toString(),
      'message': record.message,
      'error': record.error ?? '',
      'stackTrace': record.stackTrace ?? '',
    });
  });

  await beforeAppStart();

  runApp(const App());
}
