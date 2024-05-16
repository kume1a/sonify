import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../entities/audio/util/user_audio_mapper.dart';
import '../../../shared/constant.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';

class DownloadedTaskMapper {
  DownloadedTaskMapper(
    this._userAudioMapper,
  );

  final UserAudioMapper _userAudioMapper;

  DownloadedTask downloadTaskToModel(
    DownloadTask downloadTask,
  ) {
    return DownloadedTask(
      localId: null,
      id: downloadTask.id,
      savePath: downloadTask.savePath,
      fileType: downloadTask.fileType,
      payload: downloadTask.payload,
    );
  }

  DownloadedTaskEntity modelToEntity(
    DownloadedTask m, {
    String? userId,
  }) {
    return DownloadedTaskEntity(
      id: m.localId,
      userId: userId,
      taskId: m.id,
      savePath: m.savePath,
      fileType: m.fileType.name,
      payloadUserAudioId: m.payload.userAudio?.localId,
      payloadUserAudio: tryMap(m.payload.userAudio, _userAudioMapper.modelToEntity),
    );
  }

  DownloadedTask entityToModel(DownloadedTaskEntity e) {
    return DownloadedTask(
      id: e.taskId ?? kInvalidId,
      localId: e.id,
      savePath: e.savePath ?? '',
      fileType: FileType.values.byName(e.fileType ?? ''),
      payload: DownloadTaskPayload(
        userAudio: tryMap(e.payloadUserAudio, _userAudioMapper.entityToModel),
      ),
    );
  }
}
