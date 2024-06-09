import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/audio.dart';
import '../util/audio_mapper.dart';
import 'audio_local_repository.dart';

class AudioLocalRepositoryImpl with ResultWrap implements AudioLocalRepository {
  AudioLocalRepositoryImpl(
    this._audioMapper,
    this._audioEntityDao,
  );

  final AudioMapper _audioMapper;
  final AudioEntityDao _audioEntityDao;

  @override
  Future<Result<Audio>> save(Audio audio) async {
    return wrapWithResult(() async {
      final audioEntity = _audioMapper.modelToEntity(audio);

      final audioEntityId = await _audioEntityDao.insert(audioEntity);

      return audio.copyWith(id: audioEntityId);
    });
  }

  @override
  Future<Result<List<Audio>>> getByIds(List<String> audioIds) {
    return wrapWithResult(() async {
      final entities = await _audioEntityDao.getByIds(audioIds);

      return entities.map((e) => _audioMapper.entityToModel(e)).toList();
    });
  }
}
