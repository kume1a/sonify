import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/user_playlist.dart';
import '../util/user_playlist_mapper.dart';
import 'user_playlist_remote_repository.dart';

class UserPlaylistRemoteRepositoryImpl implements UserPlaylistRemoteRepository {
  UserPlaylistRemoteRepositoryImpl(
    this._userPlaylistRemoteService,
    this._userPlaylistMapper,
  );

  final UserPlaylistRemoteService _userPlaylistRemoteService;
  final UserPlaylistMapper _userPlaylistMapper;

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser() {
    return _userPlaylistRemoteService.getAllIdsByAuthUser();
  }

  @override
  Future<Either<NetworkCallError, List<UserPlaylist>>> getAllByAuthUser({
    List<String>? ids,
  }) async {
    final res = await _userPlaylistRemoteService.getAllByAuthUser(ids: ids);

    return res.map((r) => r.map(_userPlaylistMapper.dtoToModel).toList());
  }

  @override
  Future<Either<NetworkCallError, List<UserPlaylist>>> getAllFullByAuthUser({
    List<String>? playlistIds,
  }) async {
    final res = await _userPlaylistRemoteService.getAllFullByAuthUser(playlistIds: playlistIds);

    return res.map((r) => r.map(_userPlaylistMapper.dtoToModel).toList());
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllPlaylistIdsByAuthUser() {
    return _userPlaylistRemoteService.getAllPlaylistIdsByAuthUser();
  }

  @override
  Future<Either<NetworkCallError, UserPlaylist>> create({
    required String name,
  }) async {
    final res = await _userPlaylistRemoteService.create(name: name);

    return res.map(_userPlaylistMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteById(String id) {
    return _userPlaylistRemoteService.deleteById(id);
  }

  @override
  Future<Either<NetworkCallError, UserPlaylist>> updateById({
    required String id,
    String? name,
  }) async {
    final res = await _userPlaylistRemoteService.updateById(id: id, name: name);

    return res.map(_userPlaylistMapper.dtoToModel);
  }
}
