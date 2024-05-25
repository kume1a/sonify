import 'package:common_models/common_models.dart';
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
    this._audioEntityDao,
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final AudioMapper _audioMapper;
  final UserAudioMapper _userAudioMapper;
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
  Future<Result<List<String>>> getAllIdsByUserId(String userId) {
    return wrapWithResult(() => _userAudioEntityDao.getAllBAudioIdsByUserId(userId));
  }
}
