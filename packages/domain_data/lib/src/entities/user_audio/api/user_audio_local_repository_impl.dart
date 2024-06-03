import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../audio/model/user_audio.dart';
import '../../audio/util/user_audio_mapper.dart';
import 'user_audio_local_repository.dart';

class UserAudioLocalRepositoryImpl with ResultWrap implements UserAudioLocalRepository {
  UserAudioLocalRepositoryImpl(
    this._userAudioEntityDao,
    this._userAudioMapper,
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Result<List<UserAudio>>> getAllByUserId(String userId) {
    return wrapWithResult(() async {
      final audioEntities = await _userAudioEntityDao.getAllByUserId(userId);

      return audioEntities.map(_userAudioMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<UserAudio>> save(UserAudio userAudio) async {
    return wrapWithResult(() async {
      final userAudioEntity = _userAudioMapper.modelToEntity(userAudio);

      final userAudioEntityId = await _userAudioEntityDao.insert(userAudioEntity);

      return userAudio.copyWith(id: userAudioEntityId);
    });
  }

  @override
  Future<Result<int>> deleteByAudioIds(List<String> ids) {
    return wrapWithResult(() => _userAudioEntityDao.deleteByAudioIds(ids));
  }

  @override
  Future<Result<List<String>>> getAllIdsByUserId(String userId) {
    return wrapWithResult(() => _userAudioEntityDao.getAllAudioIdsByUserId(userId));
  }
}
