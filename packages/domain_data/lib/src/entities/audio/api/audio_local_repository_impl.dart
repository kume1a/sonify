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
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final AudioMapper _audioMapper;
  final UserAudioMapper _userAudioMapper;
  final AudioLikeEntityDao _audioLikeEntityDao;
  final AudioEntityDao _audioEntityDao;
  final AudioLikeMapper _audioLikeMapper;

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
          audioId: Wrapped(audioEntityId),
        ),
      );

      return userAudio.copyWith(
        localId: userAudioEntityId,
        audio: audio.copyWith(localId: audioEntityId),
      );
    });
  }

  @override
  Future<Result<int>> deleteUserAudioJoinsByIds(List<int> ids) {
    return wrapWithResult(() => _userAudioEntityDao.deleteByIds(ids));
  }

  @override
  Future<Result<AudioLike>> like({
    required String userId,
    required String audioId,
  }) async {
    return wrapWithResult(() async {
      final audioLikeEntity = AudioLikeEntity(
        id: null,
        bAudioId: audioId,
        bUserId: userId,
      );

      final localId = await _audioLikeEntityDao.insert(audioLikeEntity);

      final insertedEntity = audioLikeEntity.copyWith(id: Wrapped(localId));

      return _audioLikeMapper.entityToModel(insertedEntity);
    });
  }

  @override
  Future<EmptyResult> unlike({
    required String userId,
    required String audioId,
  }) async {
    return wrapWithEmptyResult(() => _audioLikeEntityDao.deleteByUserIdAndAudioId(
          audioId: audioId,
          userId: userId,
        ));
  }

  @override
  Future<Result<bool>> existsByUserAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(
      () => _audioLikeEntityDao.existsByUserAndAudioId(
        userId: userId,
        audioId: audioId,
      ),
    );
  }

  @override
  Future<Result<List<AudioLike>>> getAllLikedAudiosByUserId({
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
}
