import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/local_audio_file.dart';
import '../util/local_audio_file_mapper.dart';
import 'local_audio_file_repository.dart';

@LazySingleton(as: LocalAudioFileRepository)
class LocalAudioFileRepositoryImpl implements LocalAudioFileRepository {
  LocalAudioFileRepositoryImpl(
    this._audioEntityDao,
    this._localAudioFileMapper,
  );

  final AudioEntityDao _audioEntityDao;
  final LocalAudioFileMapper _localAudioFileMapper;

  @override
  Future<List<LocalAudioFile>> getAllByUserId(String userId) async {
    final audioEntities = await _audioEntityDao.getAllByUserId(userId);

    return audioEntities.map(_localAudioFileMapper.fromAudioEntity).toList();
  }

  @override
  Future<LocalAudioFile?> getById(int id) async {
    final entity = await _audioEntityDao.getById(id);

    if (entity == null) {
      return null;
    }

    return _localAudioFileMapper.fromAudioEntity(entity);
  }

  @override
  Future<LocalAudioFile> save(LocalAudioFile localAudioFile) async {
    final entity = AudioEntity();

    entity.title = localAudioFile.title;
    entity.duration = localAudioFile.duration.inSeconds;
    entity.path = localAudioFile.path;
    entity.author = localAudioFile.author;
    entity.userId = localAudioFile.userId;
    entity.sizeInBytes = localAudioFile.sizeInBytes;
    entity.youtubeVideoId = localAudioFile.youtubeVideoId;
    entity.thumbnailPath = localAudioFile.thumbnailPath;

    final entityId = await _audioEntityDao.insert(entity);

    return localAudioFile.copyWith(id: entityId);
  }
}
