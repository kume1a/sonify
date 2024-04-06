import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/util/utils.dart';
import 'server_time_offset_store.dart';

const _kPositiveDiffKey = 'server_time_positive_diff';

@LazySingleton(as: ServerTimeOffsetStore)
class SharedPrefsServerTimeOffsetStore implements ServerTimeOffsetStore {
  SharedPrefsServerTimeOffsetStore(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  @override
  int? read() {
    return callOrDefault(() => _sharedPreferences.getInt(_kPositiveDiffKey), null);
  }

  @override
  void write(int value) {
    try {
      _sharedPreferences.setInt(_kPositiveDiffKey, value);
    } catch (e) {
      Logger.root.severe(e);
    }
  }
}
