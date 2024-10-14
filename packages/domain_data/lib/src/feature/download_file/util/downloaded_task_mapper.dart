import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../entities/user_audio/util/user_audio_mapper.dart';
import '../../../shared/constant.dart';
import '../model/download_task.dart';
import '../model/file_type.dart';

class DownloadedTaskMapper {
  DownloadedTaskMapper(
    this._userAudioMapper,
  );

  final UserAudioMapper _userAudioMapper;

  DownloadedTaskEntity modelToEntity(
    DownloadTask m, {
    String? userId,
  }) {
    return DownloadedTaskEntity(
      id: m.id,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      savePath: m.savePath,
      fileType: m.fileType.name,
      payloadUserAudioId: m.payload.userAudio?.id,
      payloadUserAudio: tryMap(m.payload.userAudio, _userAudioMapper.modelToEntity),
    );
  }

  DownloadTask entityToModel(DownloadedTaskEntity e) {
    return DownloadTask.completed(
      id: e.id ?? kInvalidId,
      savePath: e.savePath ?? '',
      fileType: FileType.values.byName(e.fileType ?? ''),
      uri: Uri(),
      payload: DownloadTaskPayload(
        userAudio: tryMap(e.payloadUserAudio, _userAudioMapper.entityToModel),
      ),
    );
  }
}
