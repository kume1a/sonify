import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../playlist/api/playlist_local_repository.dart';
import '../model/user_playlist.dart';
import '../util/user_playlist_mapper.dart';
import 'user_playlist_local_repository.dart';

class UserPlaylistLocalRepositoryImpl with ResultWrap implements UserPlaylistLocalRepository {
  UserPlaylistLocalRepositoryImpl(
    this._userPlaylistEntityDao,
    this._userPlaylistMapper,
    this._dbBatchProviderFactory,
    this._playlistLocalRePository,
  );

  final UserPlaylistEntityDao _userPlaylistEntityDao;
  final UserPlaylistMapper _userPlaylistMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;
  final PlaylistLocalRepository _playlistLocalRePository;

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

  @override
  Future<Result<UserPlaylist>> create(UserPlaylist userPlaylist) {
    return wrapWithResult(
      () async {
        final entity = _userPlaylistMapper.modelToEntity(userPlaylist);

        final entityId = await _userPlaylistEntityDao.insert(entity);

        return userPlaylist.copyWith(id: entityId);
      },
    );
  }

  @override
  Future<EmptyResult> updateById({
    required String id,
    String? name,
  }) async {
    final userPlaylist = await wrapWithResult(() => _userPlaylistEntityDao.getById(id));
    if (userPlaylist.isErr) {
      return EmptyResult.err();
    }

    final playlistId = userPlaylist.dataOrThrow?.playlistId;
    if (playlistId == null) {
      return EmptyResult.err();
    }

    return wrapWithEmptyResult(
      () => _playlistLocalRePository.updateById(
        id: playlistId,
        name: name,
      ),
    );
  }

  @override
  Future<EmptyResult> deleteById(String id) async {
    final userPlaylist = await wrapWithResult(() => _userPlaylistEntityDao.getById(id));
    if (userPlaylist.isErr) {
      return EmptyResult.err();
    }

    final playlistId = userPlaylist.dataOrThrow?.playlistId;
    if (playlistId == null) {
      return EmptyResult.err();
    }

    return wrapWithEmptyResult(() => _userPlaylistEntityDao.deleteById(id));
  }

  @override
  Future<Result<UserPlaylist?>> getById(String id) {
    return wrapWithResult(() async {
      final res = await _userPlaylistEntityDao.getById(id);

      return res != null ? _userPlaylistMapper.entityToModel(res) : null;
    });
  }

  @override
  Future<Result<UserPlaylist?>> getByUserIdAndPlaylistId({
    required String userId,
    required String playlistId,
  }) {
    return wrapWithResult(() async {
      final res = await _userPlaylistEntityDao.getByUserIdAndPlaylistId(
        userId: userId,
        playlistId: playlistId,
      );

      return res != null ? _userPlaylistMapper.entityToModel(res) : null;
    });
  }
}
