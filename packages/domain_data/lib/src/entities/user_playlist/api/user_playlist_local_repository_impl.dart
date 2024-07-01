import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/user_playlist.dart';
import '../util/user_playlist_mapper.dart';
import 'user_playlist_local_repository.dart';

class UserPlaylistLocalRepositoryImpl with ResultWrap implements UserPlaylistLocalRepository {
  UserPlaylistLocalRepositoryImpl(
    this._userPlaylistEntityDao,
    this._userPlaylistMapper,
    this._dbBatchProviderFactory,
  );

  final UserPlaylistEntityDao _userPlaylistEntityDao;
  final UserPlaylistMapper _userPlaylistMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  @override
  Future<EmptyResult> bulkWrite(
    List<UserPlaylist> userPlaylists,
  ) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final userPlaylist in userPlaylists) {
        _userPlaylistEntityDao.insert(
          _userPlaylistMapper.modelToEntity(userPlaylist),
          batchProvider: batchProvider,
        );
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<Result<int>> deleteByIds(List<String> ids) {
    return wrapWithResult(() => _userPlaylistEntityDao.deleteByIds(ids));
  }

  @override
  Future<Result<List<UserPlaylist>>> getAllByUserId(String userId) {
    return wrapWithResult(() async {
      final res = await _userPlaylistEntityDao.getAllByUserId(userId);

      return res.map(_userPlaylistMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<List<String>>> getAllIdsByUserId(String userId) {
    return wrapWithResult(() => _userPlaylistEntityDao.getAllIdsByUserId(userId));
  }
}
