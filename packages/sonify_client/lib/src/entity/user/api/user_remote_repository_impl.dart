import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/update_user_body.dart';
import '../model/user.dart';
import '../util/user_mapper.dart';
import 'user_remote_repository.dart';

class UserRemoteRepositoryImpl with SafeHttpRequestWrap implements UserRemoteRepository {
  UserRemoteRepositoryImpl(
    this._apiClient,
    this._userMapper,
  );

  final ApiClient _apiClient;
  final UserMapper _userMapper;

  @override
  Future<Either<ActionFailure, User>> updateUser({
    String? name,
  }) {
    return callCatchWithActionFailure(() async {
      final body = UpdateUserBody(
        name: name,
      );

      final dto = await _apiClient.updateUser(body);

      return _userMapper.dtoToModel(dto);
    });
  }

  @override
  Future<Either<FetchFailure, User>> getAuthUser() {
    return callCatchWithFetchFailure(() async {
      final res = await _apiClient.getAuthUser();

      return _userMapper.dtoToModel(res);
    });
  }
}
