import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/hidden_user_audio.dart';
import '../util/hidden_user_audio_mapper.dart';
import 'hidden_user_audio_local_repository.dart';

class HiddenUserAudioLocalRepositoryImpl with ResultWrap implements HiddenUserAudioLocalRepository {
  HiddenUserAudioLocalRepositoryImpl(
    this._hiddenUserAudioEntityDao,
    this._hiddenUserAudioMapper,
    this._dbBatchProviderFactory,
  );

  final HiddenUserAudioEntityDao _hiddenUserAudioEntityDao;
  final HiddenUserAudioMapper _hiddenUserAudioMapper;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  @override
  Future<Result<HiddenUserAudio>> create(HiddenUserAudio audioLike) async {
    return wrapWithResult(() async {
      final insertedId = await _hiddenUserAudioEntityDao.insert(
        _hiddenUserAudioMapper.modelToEntity(audioLike),
      );

      return audioLike.copyWith(id: insertedId);
    });
  }

  @override
  Future<EmptyResult> bulkCreate(List<HiddenUserAudio> hiddenUserAudios) {
    return wrapWithEmptyResult(() async {
      final batchProvider = _dbBatchProviderFactory.newBatchProvider();

      for (final hiddenUserAudio in hiddenUserAudios) {
        final entity = _hiddenUserAudioMapper.modelToEntity(hiddenUserAudio);

        _hiddenUserAudioEntityDao.insert(entity, batchProvider);
      }

      await batchProvider.commit();
    });
  }

  @override
  Future<Result<int>> deleteByIds(List<String> ids) {
    return wrapWithResult(
      () => _hiddenUserAudioEntityDao.deleteByIds(ids),
    );
  }
}
