import 'package:common_models/common_models.dart';

import '../model/download_task.dart';

abstract interface class DownloadedTaskLocalRepository {
  Future<Result<String>> save(DownloadTask downloadTask);

  Future<Result<List<DownloadTask>>> getAllByUserId(String userId);
}
