import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/di/register_dependencies.dart';
import 'app/navigation/page_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  GlobalNavigator.navigatorKey = navigatorKey;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const App());
}
