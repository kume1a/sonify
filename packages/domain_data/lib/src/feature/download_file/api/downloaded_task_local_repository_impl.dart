import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:logging/logging.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../entities/audio/model/user_audio.dart';
import '../../../entities/audio/util/user_audio_mapper.dart';
import '../../auth/api/auth_user_info_provider.dart';
import '../model/downloaded_task.dart';
import '../util/downloaded_task_mapper.dart';
import 'downloaded_task_local_repository.dart';

class DownloadedTaskLocalRepositoryImpl with ResultWrap implements DownloadedTaskLocalRepository {
  DownloadedTaskLocalRepositoryImpl(
    this._downloadedTaskEntityDao,
    this._downloadedTaskMapper,
    this._userAudioMapper,
    this._authUserInfoProvider,
  );

  final DownloadedTaskEntityDao _downloadedTaskEntityDao;
  final DownloadedTaskMapper _downloadedTaskMapper;
  final UserAudioMapper _userAudioMapper;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<Result<int>> save(DownloadedTask downloadedTask, {UserAudio? payloadUserAudio}) async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.info('save downloaded task failed, authUserId is null');
      return Result.err();
    }

    return wrapWithResult(() async {
      final downloadedTaskEntity = _downloadedTaskMapper.modelToEntity(
        downloadedTask,
        userId: authUserId,
      );

      final payloadUserAudioEntity = tryMap(
        payloadUserAudio,
        _userAudioMapper.modelToEntity,
      );

      return _downloadedTaskEntityDao.insert(
        downloadedTaskEntity,
        payloadUserAudioEntity: payloadUserAudioEntity,
      );
    });
  }

  @override
  Future<Result<List<DownloadedTask>>> getAllByUserId(String userId) {
    return wrapWithResult(() async {
      final downloadedTaskEntities = await _downloadedTaskEntityDao.getAllByUserId(userId);

      return downloadedTaskEntities.map(_downloadedTaskMapper.entityToModel).toList();
    });
  }
}
