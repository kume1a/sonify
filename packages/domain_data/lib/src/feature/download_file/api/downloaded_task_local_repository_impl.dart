import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../auth/api/auth_user_info_provider.dart';
import '../model/downloaded_task.dart';
import '../util/downloaded_task_mapper.dart';
import 'downloaded_task_local_repository.dart';

class DownloadedTaskLocalRepositoryImpl with ResultWrap implements DownloadedTaskLocalRepository {
  DownloadedTaskLocalRepositoryImpl(
    this._downloadedTaskEntityDao,
    this._downloadedTaskMapper,
    this._authUserInfoProvider,
  );

  final DownloadedTaskEntityDao _downloadedTaskEntityDao;
  final DownloadedTaskMapper _downloadedTaskMapper;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<Result<String>> save(DownloadedTask downloadedTask) async {
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

      return _downloadedTaskEntityDao.insert(downloadedTaskEntity);
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
