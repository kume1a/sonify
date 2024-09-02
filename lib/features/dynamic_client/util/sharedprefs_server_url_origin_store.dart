import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/server_url_origin.dart';
import 'server_url_origin_store.dart';

@LazySingleton(as: ServerUrlOriginStore)
class SharedprefsServerUrlOriginStore implements ServerUrlOriginStore {
  SharedprefsServerUrlOriginStore(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  static const String _key = 'api_url_origin';

  @override
  ServerUrlOrigin read() {
    final value = _sharedPreferences.getString(_key);

    if (value == null) {
      return ServerUrlOrigin.remote;
    }

    return ServerUrlOrigin.values.firstWhereOrNull((e) => e.toString() == value) ?? ServerUrlOrigin.remote;
  }

  @override
  Future<void> write(ServerUrlOrigin origin) {
    return _sharedPreferences.setString(_key, origin.toString());
  }
}
