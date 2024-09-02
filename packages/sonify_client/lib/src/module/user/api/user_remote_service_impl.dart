import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../model/update_user_body.dart';
import '../model/user_dto.dart';
import 'user_remote_service.dart';

class UserRemoteServiceImpl with SafeHttpRequestWrap implements UserRemoteService {
  UserRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, UserDto>> updateUser({
    String? name,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = UpdateUserBody(
        name: name,
      );

      return _apiClientProvider.get().updateAuthUser(body);
    });
  }

  @override
  Future<Either<NetworkCallError, UserDto>> getAuthUser() {
    return callCatchHandleNetworkCallError(
      () => _apiClientProvider.get().getAuthUser(),
    );
  }
}
