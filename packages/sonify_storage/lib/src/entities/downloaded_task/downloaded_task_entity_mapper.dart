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
      id: m[DownloadedTask_.id] as String?,
      createdAtMillis: m[DownloadedTask_.createdAtMillis] as int?,
      userId: m[DownloadedTask_.userId] as String?,
      savePath: m[DownloadedTask_.savePath] as String?,
      fileType: m[DownloadedTask_.fileType] as String?,
      payloadUserAudioId: m[DownloadedTask_.payloadUserAudioId] as String?,
      payloadUserAudio: _userAudioEntityMapper.joinedMapToEntity(m),
    );
  }

  DownloadedTaskEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[DownloadedTask_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return DownloadedTaskEntity(
      id: id,
      createdAtMillis: m[DownloadedTask_.joinedCreatedAtMillis] as int?,
      userId: m[DownloadedTask_.joinedUserId] as String?,
      savePath: m[DownloadedTask_.joinedSavePath] as String?,
      fileType: m[DownloadedTask_.joinedFileType] as String?,
      payloadUserAudioId: m[DownloadedTask_.joinedPayloadUserAudioId] as String?,
      payloadUserAudio: _userAudioEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(DownloadedTaskEntity e) {
    return {
      DownloadedTask_.id: e.id,
      DownloadedTask_.createdAtMillis: e.createdAtMillis,
      DownloadedTask_.userId: e.userId,
      DownloadedTask_.savePath: e.savePath,
      DownloadedTask_.fileType: e.fileType,
      DownloadedTask_.payloadUserAudioId: e.payloadUserAudioId,
    };
  }
}
