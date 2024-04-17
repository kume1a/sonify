import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/user.dart';
import '../util/user_mapper.dart';
import 'user_remote_repository.dart';

class UserRemoteRepositoryImpl implements UserRemoteRepository {
  UserRemoteRepositoryImpl(
    this._userRemoteService,
    this._userMapper,
  );

  final UserRemoteService _userRemoteService;
  final UserMapper _userMapper;

  @override
  Future<Either<NetworkCallError, User>> updateUser({
    String? name,
  }) async {
    final res = await _userRemoteService.updateUser(
      name: name,
    );

    return res.map(_userMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, User>> getAuthUser() async {
    final res = await _userRemoteService.getAuthUser();

    return res.map(_userMapper.dtoToModel);
  }
}
