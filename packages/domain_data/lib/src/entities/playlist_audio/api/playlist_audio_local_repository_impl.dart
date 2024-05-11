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
  Future<EmptyResult> batchCreate(List<PlaylistAudio> playlistAudios) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final playlistAudio in playlistAudios) {
        _playlistAudioEntityDao.batchCreate(
          _playlistAudioMapper.modelToEntity(playlistAudio),
          batchProvider: batchProvider,
        );
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<EmptyResult> deleteMany(List<PlaylistAudio> playlistAudios) {
    return wrapWithEmptyResult(() {
      final entities = playlistAudios.map(_playlistAudioMapper.modelToEntity).toList();

      return _playlistAudioEntityDao.deleteMany(entities);
    });
  }

  @override
  Future<Result<List<PlaylistAudio>>> getAll() {
    return wrapWithResult(() async {
      final res = await _playlistAudioEntityDao.getAll();

      return res.map(_playlistAudioMapper.entityToModel).toList();
    });
  }
}
