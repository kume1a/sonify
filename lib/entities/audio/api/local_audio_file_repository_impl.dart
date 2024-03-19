import 'package:injectable/injectable.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/local_audio_file.dart';
import '../util/audio_entity_to_local_audio_file.dart';
import 'local_audio_file_repository.dart';

@LazySingleton(as: LocalAudioFileRepository)
class LocalAudioFileRepositoryImpl implements LocalAudioFileRepository {
  LocalAudioFileRepositoryImpl(
    this._audioEntityDao,
    this._audioEntityToLocalAudioFile,
  );

  final AudioEntityDao _audioEntityDao;
  final AudioEntityToLocalAudioFile _audioEntityToLocalAudioFile;

  @override
  Future<List<LocalAudioFile>> getAll() async {
    final audioEntities = await _audioEntityDao.getAll();

    return audioEntities.map(_audioEntityToLocalAudioFile.call).toList();
  }

  @override
  Future<LocalAudioFile?> getById(int id) async {
    final entity = await _audioEntityDao.getById(id);

    if (entity == null) {
      return null;
    }

    return _audioEntityToLocalAudioFile(entity);
  }

  @override
  Future<void> save(LocalAudioFile localAudioFile) {
    final entity = AudioEntity();

    entity.title = localAudioFile.title;
    entity.duration = localAudioFile.duration.inSeconds;
    entity.path = localAudioFile.path;
    entity.author = localAudioFile.author;
    entity.userId = localAudioFile.userId;
    entity.sizeInBytes = localAudioFile.sizeInBytes;
    entity.youtubeVideoId = localAudioFile.youtubeVideoId;
    entity.thumbnailPath = localAudioFile.thumbnailPath;
    return _audioEntityDao.insert(entity);
  }
}
