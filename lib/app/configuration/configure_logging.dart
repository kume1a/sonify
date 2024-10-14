import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void configureLogging() {
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
}
