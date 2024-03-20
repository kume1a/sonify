import 'package:common_network_components/common_network_components.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import 'auth_user_info_provider.dart';

@LazySingleton(as: AuthUserInfoProvider)
class AuthUserInfoProviderImpl implements AuthUserInfoProvider {
  AuthUserInfoProviderImpl(
    this._authTokenStore,
  );

  final AuthTokenStore _authTokenStore;

  @override
  Future<String?> getId() async {
    final accessToken = await _authTokenStore.readAccessToken();

    if (accessToken == null) {
      return null;
    }

    try {
      final payload = JwtDecoder.parseJwt(accessToken);

      if (!payload.containsKey('userId')) {
        return null;
      }

      return payload['userId'] as String?;
    } catch (e) {
      Logger.root.severe(e);
    }

    return null;
  }
}
