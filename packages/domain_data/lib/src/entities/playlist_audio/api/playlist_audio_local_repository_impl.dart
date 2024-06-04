import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/playlist_audio.dart';
import '../util/playlist_audio_mapper.dart';
import 'playlist_audio_local_repository.dart';

class PlaylistAudioLocalRepositoryImpl with ResultWrap implements PlaylistAudioLocalRepository {
  PlaylistAudioLocalRepositoryImpl(
    this._playlistAudioEntityDao,
    this._playlistAudioMapper,
    this._dbBatchProviderFactory,
  );

  final PlaylistAudioEntityDao _playlistAudioEntityDao;
  final PlaylistAudioMapper _playlistAudioMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  @override
  Future<Result<PlaylistAudio>> create(PlaylistAudio playlistAudios) {
    return wrapWithResult(
      () async {
        final insertedId =
            await _playlistAudioEntityDao.insert(_playlistAudioMapper.modelToEntity(playlistAudios));

        return playlistAudios.copyWith(id: insertedId);
      },
    );
  }

  @override
  Future<EmptyResult> batchCreate(List<PlaylistAudio> playlistAudios) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final playlistAudio in playlistAudios) {
        _playlistAudioEntityDao.insert(
          _playlistAudioMapper.modelToEntity(playlistAudio),
          batchProvider: batchProvider,
        );
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<Result<int>> deleteByIds(List<String> ids) {
    return wrapWithResult(() => _playlistAudioEntityDao.deleteByIds(ids));
  }

  @override
  Future<Result<List<PlaylistAudio>>> getAll() {
    return wrapWithResult(() async {
      final res = await _playlistAudioEntityDao.getAll();

      return res.map(_playlistAudioMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<List<String>>> getAllByPlaylistIds(List<String> playlistIds) {
    return wrapWithResult(() => _playlistAudioEntityDao.getAllIdsByPlaylistIds(playlistIds));
  }
}
