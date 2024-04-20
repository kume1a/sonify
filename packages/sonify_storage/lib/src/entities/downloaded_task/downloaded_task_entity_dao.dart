import '../user_audio/user_audio_entity.dart';
import 'downloaded_task_entity.dart';

abstract interface class DownloadedTaskEntityDao {
  Future<int> insert(
    DownloadedTaskEntity entity, {
    UserAudioEntity? payloadUserAudioEntity,
  });

  Future<List<DownloadedTaskEntity>> getAllByUserId(String userId);
}
