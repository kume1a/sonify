import 'downloaded_task_entity.dart';

abstract interface class DownloadedTaskEntityDao {
  Future<String> insert(DownloadedTaskEntity entity);

  Future<List<DownloadedTaskEntity>> getAllByUserId(String userId);
}
