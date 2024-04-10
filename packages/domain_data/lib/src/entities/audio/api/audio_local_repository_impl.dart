import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio.dart';
import '../model/user_audio.dart';
import '../util/audio_mapper.dart';
import '../util/user_audio_mapper.dart';
import 'audio_local_repository.dart';

class AudioLocalRepositoryImpl implements AudioLocalRepository {
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
  Future<List<UserAudio>> getAllByUserId(String userId) async {
    final audioEntities = await _userAudioEntityDao.getAllByUserId(userId);

    return audioEntities.map(_userAudioMapper.fromEntity).toList();
  }

  @override
  Future<Audio?> getById(int id) async {
    final entity = await _audioEntityDao.getById(id);

    if (entity == null) {
      return null;
    }

    return _audioMapper.fromEntity(entity);
  }

  @override
  Future<UserAudio?> save(UserAudio userAudio) async {
    final audio = userAudio.audio;
    if (audio == null) {
      return null;
    }

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
  }
}
