import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/util/utils.dart';
import 'spotify_creds_store.dart';

@LazySingleton(as: SpotifyCredsStore)
class SharedPrefsSpotifyCredsStore implements SpotifyCredsStore {
  SharedPrefsSpotifyCredsStore(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  static const String _keyAccessToken = 'spotify_access_token';
  static const String _keyRefreshToken = 'spotify_refresh_token';
  static const String _keyTokenExpiry = 'spotify_token_expiry';

  @override
  Future<void> clear() async {
    try {
      await Future.wait([
        _sharedPreferences.remove(_keyAccessToken),
        _sharedPreferences.remove(_keyRefreshToken),
        _sharedPreferences.remove(_keyTokenExpiry),
      ]);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  @override
  String? readAccessToken() {
    return callOrDefault(() => _sharedPreferences.getString(_keyAccessToken), null);
  }

  @override
  String? readRefreshToken() {
    return callOrDefault(() => _sharedPreferences.getString(_keyRefreshToken), null);
  }

  @override
  DateTime? readTokenExpiry() {
    return callOrDefault(
      () {
        final expiry = _sharedPreferences.getInt(_keyTokenExpiry);
        return expiry != null ? DateTime.fromMillisecondsSinceEpoch(expiry) : DateTime.now();
      },
      null,
    );
  }

  @override
  Future<void> writeAccessToken(String token) async {
    try {
      await _sharedPreferences.setString(_keyAccessToken, token);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  @override
  Future<void> writeRefreshToken(String token) async {
    try {
      await _sharedPreferences.setString(_keyRefreshToken, token);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  @override
  Future<void> writeTokenExpiresIn(int expiresInSeconds) async {
    try {
      final expiry = DateTime.now().add(Duration(seconds: expiresInSeconds));

      await _sharedPreferences.setInt(_keyTokenExpiry, expiry.millisecondsSinceEpoch);
    } catch (e) {
      Logger.root.severe(e);
    }
  }
}
