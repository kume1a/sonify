import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../audio/util/delete_unused_local_audio.dart';
import '../model/playlist_audio.dart';
import '../util/playlist_audio_mapper.dart';
import 'playlist_audio_local_repository.dart';

class PlaylistAudioLocalRepositoryImpl with ResultWrap implements PlaylistAudioLocalRepository {
  PlaylistAudioLocalRepositoryImpl(
    this._playlistAudioEntityDao,
    this._playlistAudioMapper,
    this._dbBatchProviderFactory,
    this._deleteUnusedLocalAudio,
  );

  final PlaylistAudioEntityDao _playlistAudioEntityDao;
  final PlaylistAudioMapper _playlistAudioMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;
  final DeleteUnusedLocalAudio _deleteUnusedLocalAudio;

  @override
  Future<Result<PlaylistAudio>> create(PlaylistAudio playlistAudio) {
    return wrapWithResult(
      () async {
        final entity = _playlistAudioMapper.modelToEntity(playlistAudio);

        final insertedId = await _playlistAudioEntityDao.insert(entity);

        return playlistAudio.copyWith(id: insertedId);
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
  Future<Result<int>> deleteByIds(List<String> ids) async {
    final audioIdsRes = await wrapWithResult(() => _playlistAudioEntityDao.getAudioIdsByIds(ids));
    if (audioIdsRes.isErr) {
      return Result.err();
    }

    final deleteResult = await wrapWithResult(() => _playlistAudioEntityDao.deleteByIds(ids));

    final deleteUnusedAudiosRes = await _deleteUnusedLocalAudio.deleteByIds(audioIdsRes.dataOrThrow);
    if (deleteUnusedAudiosRes.isErr) {
      return Result.err();
    }

    return deleteResult;
  }

  @override
  Future<EmptyResult> deleteById(String id) async {
    final audioIdRes = await wrapWithResult(() => _playlistAudioEntityDao.getAudioIdById(id));
    if (audioIdRes.isErr || audioIdRes.dataOrNull == null) {
      return EmptyResult.err();
    }

    final deleteRes = await wrapWithEmptyResult(() => _playlistAudioEntityDao.deleteById(id));

    final deleteUnusedAudioRes = await _deleteUnusedLocalAudio.deleteById(audioIdRes.dataOrThrow!);
    if (deleteUnusedAudioRes.isErr) {
      return EmptyResult.err();
    }

    return deleteRes;
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

  @override
  Future<Result<List<PlaylistAudio>>> getAllWithAudios({
    required String playlistId,
    String? searchQuery,
  }) {
    return wrapWithResult(() async {
      final res = await _playlistAudioEntityDao.getAllWithAudio(
        playlistId: playlistId,
        searchQuery: searchQuery,
      );

      return res.map(_playlistAudioMapper.entityToModel).toList();
    });
  }
}
