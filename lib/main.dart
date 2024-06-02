import 'dart:developer';

import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/configuration/before_app_start.dart';
import 'app/configuration/global_http_overrides.dart';
import 'app/di/register_dependencies.dart';
import 'app/navigation/page_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnvironment.load();

  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  GlobalNavigator.navigatorKey = navigatorKey;

  GlobalHttpOverrides.configure();

  VVOConfig.password.minLength = 6;

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  await beforeAppStart();

  runApp(const App());
}
