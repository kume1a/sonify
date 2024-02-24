import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import 'auth_status_provider.dart';

@LazySingleton(as: AuthStatusProvider)
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
