import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ConfigureSecureStorage {
  ConfigureSecureStorage(
    this._secureStorage,
    this._sharedPreferences,
  );

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  static const _keyHasRunBefore = 'has_run_before';

  Future<void> call() async {
    final hasRunBefore = _sharedPreferences.getBool(_keyHasRunBefore);

    if (hasRunBefore == null || !hasRunBefore) {
      await _secureStorage.deleteAll();
      _sharedPreferences.setBool(_keyHasRunBefore, true);
    }
  }
}
