import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/di/register_dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const App());
}
