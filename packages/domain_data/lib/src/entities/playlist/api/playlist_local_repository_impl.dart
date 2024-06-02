import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/playlist.dart';

import '../util/playlist_mapper.dart';
import 'playlist_local_repository.dart';

class PlaylistLocalRepositoryImpl with ResultWrap implements PlaylistLocalRepository {
  PlaylistLocalRepositoryImpl(
    this._playlistEntityDao,
    this._dbBatchProviderFactory,
    this._playlistMapper,
    this._playlistAudioEntityDao,
  );

  final PlaylistEntityDao _playlistEntityDao;
  final DbBatchProviderFactory _dbBatchProviderFactory;
  final PlaylistMapper _playlistMapper;
  final PlaylistAudioEntityDao _playlistAudioEntityDao;

  @override
  Future<EmptyResult> bulkWrite(List<Playlist> playlists) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final playlist in playlists) {
        _playlistEntityDao.insert(
          _playlistMapper.modelToEntity(playlist),
          batchProvider: batchProvider,
        );
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<Result<int>> deleteByIds(List<String> ids) {
    return wrapWithResult(() => _playlistEntityDao.deleteByIds(ids));
  }

  @override
  Future<Result<Playlist?>> getById(String id) {
    return wrapWithResult(() async {
      final res = await _playlistEntityDao.getById(id);

      final playlistAudios = await _playlistAudioEntityDao.getAllWithAudio(id);

      return tryMap(res, (e) => _playlistMapper.entityToModel(e, audioEntities: playlistAudios));
    });
  }
}
