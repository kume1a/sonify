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
  Future<void> save(LocalAudioFile localAudioFile) {
    final entity = AudioEntity();

    entity.path = localAudioFile.path;
    entity.title = localAudioFile.title;
    entity.sizeInKb = localAudioFile.sizeInKb;
    entity.imagePath = localAudioFile.imagePath;
    entity.author = localAudioFile.author;

    return _audioEntityDao.insert(entity);
  }
}
