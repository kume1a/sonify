import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio_like.dart';
import '../util/audio_like_mapper.dart';
import 'audiolike_local_repository.dart';

class AudioLikeLocalRepositoryImpl with ResultWrap implements AudioLikeLocalRepository {
  AudioLikeLocalRepositoryImpl(
    this._audioLikeEntityDao,
    this._audioLikeMapper,
    this._dbBatchProviderFactory,
  );

  final AudioLikeEntityDao _audioLikeEntityDao;
  final AudioLikeMapper _audioLikeMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  @override
  Future<Result<AudioLike>> create(AudioLike audioLike) async {
    return wrapWithResult(() async {
      await _audioLikeEntityDao.insert(
        _audioLikeMapper.modelToEntity(audioLike),
      );

      return audioLike;
    });
  }

  @override
  Future<EmptyResult> deleteByAudioAndUserId({
    required String userId,
    required String audioId,
  }) async {
    return wrapWithEmptyResult(
      () => _audioLikeEntityDao.deleteByUserIdAndAudioId(
        audioId: audioId,
        userId: userId,
      ),
    );
  }

  @override
  Future<Result<bool>> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(
      () => _audioLikeEntityDao.existsByUserIdAndAudioId(
        userId: userId,
        audioId: audioId,
      ),
    );
  }

  @override
  Future<Result<List<AudioLike>>> getAllByUserId({
    required String userId,
  }) {
    return wrapWithResult(() async {
      final res = await _audioLikeEntityDao.getAllByUserId(userId);

      return res.map(_audioLikeMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<AudioLike?>> getByUserAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(() async {
      final res = await _audioLikeEntityDao.getByUserAndAudioId(userId: userId, audioId: audioId);

      return tryMap(res, _audioLikeMapper.entityToModel);
    });
  }

  @override
  Future<EmptyResult> bulkCreate(List<AudioLike> audioLikes) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final audioLike in audioLikes) {
        final audioLikeEntity = _audioLikeMapper.modelToEntity(audioLike);

        _audioLikeEntityDao.insert(audioLikeEntity, batchProvider);
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<Result<int>> deleteByIds(List<String> ids) {
    return wrapWithResult(
      () => _audioLikeEntityDao.deleteByIds(ids),
    );
  }
}
