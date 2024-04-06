import 'package:logging/logging.dart';

Future<T> callOrDefaultAsync<T>(Future<T> Function() fn, T defaultValue) {
  try {
    return fn();
  } catch (e) {
    Logger.root.severe('callOrDefaultAsync ', e);
  }

  return Future.value(defaultValue);
}

T callOrDefault<T>(T Function() fn, T defaultValue) {
  try {
    return fn();
  } catch (e) {
    Logger.root.severe('callOrDefault ', e);
  }

  return defaultValue;
}

extension StringX on String? {
  bool get notNullOrEmpty => this != null && this?.isNotEmpty == true;
}
