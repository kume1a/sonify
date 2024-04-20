import 'package:sonify_client/sonify_client.dart';

import 'auth_status_provider.dart';

class AuthStatusProviderImpl implements AuthStatusProvider {
  AuthStatusProviderImpl(
    this._authTokenStore,
  );

  final AuthTokenStore _authTokenStore;

  @override
  Future<bool> get() {
    return _authTokenStore.hasAccessToken();
  }
}
