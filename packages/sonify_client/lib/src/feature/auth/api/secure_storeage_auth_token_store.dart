import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_store.dart';

class SecureStoreageTokenStoreImpl implements AuthTokenStore {
  SecureStoreageTokenStoreImpl(
    this._secureStorage,
  );

  final FlutterSecureStorage _secureStorage;

  static const String _keyAccessToken = 'key_access_token';

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.delete(key: _keyAccessToken);
    } catch (e) {
      /**/
    }
  }

  @override
  Future<String?> readAccessToken() async {
    try {
      return _secureStorage.read(key: _keyAccessToken);
    } catch (e) {
      /**/
    }

    return null;
  }

  @override
  Future<void> writeAccessToken(String accessToken) async {
    try {
      return _secureStorage.write(key: _keyAccessToken, value: accessToken);
    } catch (e) {
      /**/
    }
  }

  @override
  Future<bool> hasAccessToken() async {
    try {
      final accessToken = await _secureStorage.read(key: _keyAccessToken);

      return accessToken != null;
    } catch (e) {
      /**/
    }

    return false;
  }
}
