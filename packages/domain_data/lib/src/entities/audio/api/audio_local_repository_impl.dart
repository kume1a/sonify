import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/user_audio.dart';
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
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final AudioMapper _audioMapper;
  final UserAudioMapper _userAudioMapper;
  final AudioLikeEntityDao _audioLikeEntityDao;
  final AudioEntityDao _audioEntityDao;

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
  Future<void> like({
    required String userId,
    required String audioId,
  }) async {
    try {
      final audioLikeEntity = AudioLikeEntity(
        id: null,
        bAudioId: audioId,
        bUserId: userId,
      );

      await _audioLikeEntityDao.insert(audioLikeEntity);
    } catch (e) {
      Logger.root.info('Error in like: $e');
    }
  }
}
