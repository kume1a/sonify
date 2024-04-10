import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio.dart';
import '../util/audio_mapper.dart';
import 'audio_local_repository.dart';

class AudioLocalRepositoryImpl implements AudioLocalRepository {
  AudioLocalRepositoryImpl(
    this._audioEntityDao,
    this._audioMapper,
  );

  final AudioEntityDao _audioEntityDao;
  final AudioMapper _audioMapper;

  @override
  Future<List<Audio>> getAllByUserId(String userId) async {
    final audioEntities = await _audioEntityDao.getAllByUserId(userId);

    return audioEntities.map(_audioMapper.fromEntity).toList();
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
  Future<Audio> save(Audio audio) async {
    final entity = AudioEntity();

    entity.createdAtMillis = audio.createdAt?.millisecondsSinceEpoch;
    entity.title = audio.title;
    entity.durationMs = audio.durationMs;
    entity.path = audio.path;
    entity.author = audio.author;
    entity.sizeBytes = audio.sizeBytes;
    entity.youtubeVideoId = audio.youtubeVideoId;
    entity.spotifyId = audio.spotifyId;
    entity.thumbnailPath = audio.thumbnailPath;
    entity.thumbnailUrl = audio.thumbnailUrl;

    final entityId = await _audioEntityDao.insert(entity);

    return audio.copyWith(localId: entityId);
  }
}
