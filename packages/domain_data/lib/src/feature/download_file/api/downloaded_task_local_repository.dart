import 'package:common_models/common_models.dart';

import '../model/downloaded_task.dart';

abstract interface class DownloadedTaskLocalRepository {
  Future<Result<String>> save(DownloadedTask downloadedTask);

  Future<Result<List<DownloadedTask>>> getAllByUserId(String userId);
}
