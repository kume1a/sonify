import '../../db/tables.dart';
import '../user_audio/user_audio_entity_mapper.dart';
import 'downloaded_task_entity.dart';

class DownloadedTaskEntityMapper {
  DownloadedTaskEntityMapper(
    this._userAudioEntityMapper,
  );

  final UserAudioEntityMapper _userAudioEntityMapper;

  DownloadedTaskEntity mapToEntity(Map<String, dynamic> m) {
    return DownloadedTaskEntity(
      id: m[DownloadedTaskEntity_.id] as int?,
      bUserId: m[DownloadedTaskEntity_.bUserId] as String?,
      taskId: m[DownloadedTaskEntity_.taskId] as String?,
      savePath: m[DownloadedTaskEntity_.savePath] as String?,
      fileType: m[DownloadedTaskEntity_.fileType] as String?,
      payloadUserAudioId: m[DownloadedTaskEntity_.payloadUserAudioId] as int?,
      payloadUserAudio: _userAudioEntityMapper.joinedMapToEntity(m),
    );
  }

  DownloadedTaskEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[DownloadedTaskEntity_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return DownloadedTaskEntity(
      id: id,
      bUserId: m[DownloadedTaskEntity_.joinedBUserId] as String?,
      taskId: m[DownloadedTaskEntity_.joinedTaskId] as String?,
      savePath: m[DownloadedTaskEntity_.joinedSavePath] as String?,
      fileType: m[DownloadedTaskEntity_.joinedFileType] as String?,
      payloadUserAudioId: m[DownloadedTaskEntity_.joinedPayloadUserAudioId] as int?,
      payloadUserAudio: _userAudioEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(DownloadedTaskEntity e) {
    return {
      DownloadedTaskEntity_.id: e.id,
      DownloadedTaskEntity_.bUserId: e.bUserId,
      DownloadedTaskEntity_.taskId: e.taskId,
      DownloadedTaskEntity_.savePath: e.savePath,
      DownloadedTaskEntity_.fileType: e.fileType,
      DownloadedTaskEntity_.payloadUserAudioId: e.payloadUserAudioId,
    };
  }
}
