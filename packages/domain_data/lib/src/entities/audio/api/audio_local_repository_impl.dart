import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio_like.dart';
import '../model/user_audio.dart';
import '../util/audio_like_mapper.dart';
import '../util/audio_mapper.dart';
import '../util/user_audio_mapper.dart';
import 'audio_local_repository.dart';

class AudioLocalRepositoryImpl with ResultWrap implements AudioLocalRepository {
  AudioLocalRepositoryImpl(
    this._userAudioEntityDao,
    this._audioMapper,
    this._userAudioMapper,
    this._audioLikeEntityDao,
    this._audioEntityDao,
    this._audioLikeMapper,
    this._dbBatchProviderFactory,
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final AudioMapper _audioMapper;
  final UserAudioMapper _userAudioMapper;
  final AudioLikeEntityDao _audioLikeEntityDao;
  final AudioEntityDao _audioEntityDao;
  final AudioLikeMapper _audioLikeMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  @override
  Future<Result<List<UserAudio>>> getAllByUserId(String userId) {
    return wrapWithResult(() async {
      final audioEntities = await _userAudioEntityDao.getAllByUserId(userId);

      return audioEntities.map(_userAudioMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<UserAudio>> save(UserAudio userAudio) async {
    final audio = userAudio.audio;
    if (audio == null) {
      return Result.err();
    }

    return wrapWithResult(() async {
      final audioEntity = _audioMapper.modelToEntity(audio);
      final userAudioEntity = _userAudioMapper.modelToEntity(userAudio);

      final audioEntityId = await _audioEntityDao.insert(audioEntity);
      final userAudioEntityId = await _userAudioEntityDao.insert(
        userAudioEntity.copyWith(
          audioId: Wrapped(audioEntity.id),
        ),
      );

      return userAudio.copyWith(
        id: userAudioEntityId,
        audio: audio.copyWith(id: audioEntityId),
      );
    });
  }

  @override
  Future<Result<int>> deleteUserAudioJoinsByAudioIds(List<String> ids) {
    return wrapWithResult(() => _userAudioEntityDao.deleteByAudioIds(ids));
  }

  @override
  Future<Result<AudioLike>> createAudioLike(AudioLike audioLike) async {
    return wrapWithResult(() async {
      await _audioLikeEntityDao.insert(
        _audioLikeMapper.modelToEntity(audioLike),
      );

      return audioLike;
    });
  }

  @override
  Future<EmptyResult> deleteAudioLikeByAudioAndUserId({
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
  Future<Result<List<AudioLike>>> getAllAudioLikesByUserId({
    required String userId,
  }) {
    return wrapWithResult(() async {
      final res = await _audioLikeEntityDao.getAllByUserId(userId);

      return res.map(_audioLikeMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<AudioLike?>> getAudioLikeByUserAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(() async {
      final res = await _audioLikeEntityDao.getByUserAndAudioId(userId: userId, audioId: audioId);

      return tryMap(res, _audioLikeMapper.entityToModel);
    });
  }

  @override
  Future<Result<List<String>>> getAllIdsByUserId(String userId) {
    return wrapWithResult(() => _userAudioEntityDao.getAllBAudioIdsByUserId(userId));
  }

  @override
  Future<EmptyResult> bulkWriteAudioLikes(List<AudioLike> audioLikes) {
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
  Future<Result<int>> deleteAudioLikesByIds(List<String> ids) {
    return wrapWithResult(
      () => _audioLikeEntityDao.deleteByIds(ids),
    );
  }
}
