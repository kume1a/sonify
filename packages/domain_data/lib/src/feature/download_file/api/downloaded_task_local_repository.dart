import 'package:common_models/common_models.dart';

import '../../../entities/audio/model/user_audio.dart';
import '../model/downloaded_task.dart';

abstract interface class DownloadedTaskLocalRepository {
  Future<Result<String>> save(
    DownloadedTask downloadedTask, {
    UserAudio? payloadUserAudio,
  });

  Future<Result<List<DownloadedTask>>> getAllByUserId(String userId);
}
