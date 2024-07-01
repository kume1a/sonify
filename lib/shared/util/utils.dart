import 'dart:math' as math;

import 'package:logging/logging.dart';

final _engLetterRegex = RegExp(r'^[a-zA-Z]+$');

Future<T> callOrDefaultAsync<T>(Future<T> Function() fn, T defaultValue) {
  try {
    return fn();
  } catch (e) {
    Logger.root.severe('callOrDefaultAsync $e');
  }

  return Future.value(defaultValue);
}

T callOrDefault<T>(T Function() fn, T defaultValue) {
  try {
    return fn();
  } catch (e) {
    Logger.root.severe('callOrDefault $e');
  }

  return defaultValue;
}

extension StringX on String? {
  bool get notNullOrEmpty => this != null && this?.isNotEmpty == true;

  bool get isNullOrEmpty => this == null || this?.isEmpty == true;

  bool get isEngLetter => this != null && _engLetterRegex.hasMatch(this!);
}

double deg2rad(double deg) {
  return deg / 180.0 * math.pi;
}
