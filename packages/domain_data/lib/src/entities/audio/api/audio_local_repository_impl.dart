import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio.dart';
import '../model/user_audio.dart';
import '../util/audio_mapper.dart';
import '../util/user_audio_mapper.dart';
import 'audio_local_repository.dart';

class AudioLocalRepositoryImpl with ResultWrap implements AudioLocalRepository {
  AudioLocalRepositoryImpl(
    this._audioEntityDao,
    this._userAudioEntityDao,
    this._audioMapper,
    this._userAudioMapper,
    this._createUserAudioWithAudio,
  );

  final AudioEntityDao _audioEntityDao;
  final UserAudioEntityDao _userAudioEntityDao;
  final AudioMapper _audioMapper;
  final UserAudioMapper _userAudioMapper;
  final CreateUserAudioWithAudio _createUserAudioWithAudio;

  @override
  Future<Result<List<UserAudio>>> getAllByUserId(String userId) {
    return wrapWithResult(() async {
      final audioEntities = await _userAudioEntityDao.getAllByUserId(userId);

      return audioEntities.map(_userAudioMapper.fromEntity).toList();
    });
  }

  @override
  Future<Result<Audio?>> getById(int id) {
    return wrapWithResult(() async {
      final entity = await _audioEntityDao.getById(id);

      if (entity == null) {
        return null;
      }

      return _audioMapper.fromEntity(entity);
    });
  }

  @override
  Future<Result<UserAudio>> save(UserAudio userAudio) async {
    final audio = userAudio.audio;
    if (audio == null) {
      return resultErr();
    }

    return wrapWithResult(() async {
      final audioEntity = AudioEntity();

      audioEntity.remoteId = audio.id;
      audioEntity.createdAtMillis = audio.createdAt?.millisecondsSinceEpoch;
      audioEntity.title = audio.title;
      audioEntity.durationMs = audio.durationMs;
      audioEntity.path = audio.path;
      audioEntity.author = audio.author;
      audioEntity.sizeBytes = audio.sizeBytes;
      audioEntity.youtubeVideoId = audio.youtubeVideoId;
      audioEntity.spotifyId = audio.spotifyId;
      audioEntity.thumbnailPath = audio.thumbnailPath;
      audioEntity.thumbnailUrl = audio.thumbnailUrl;

      final userAudioEntity = UserAudioEntity();

      userAudioEntity.bUserId = userAudio.userId;
      userAudioEntity.bAudioId = userAudio.audioId;
      userAudioEntity.createdAtMillis = userAudio.createdAt?.millisecondsSinceEpoch;

      // ---------------------

      final ids = await _createUserAudioWithAudio(
        audio: audioEntity,
        userAudio: userAudioEntity,
      );

      return userAudio.copyWith(
        localId: ids.userAudioEntityId,
        audio: audio.copyWith(localId: ids.audioEntityId),
      );
    });
  }

  @override
  Future<Result<int>> deleteUserAudioJoinsByIds(List<int> ids) {
    return wrapWithResult(() => _userAudioEntityDao.deleteByIds(ids));
  }
}
