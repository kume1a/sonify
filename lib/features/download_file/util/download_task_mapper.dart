import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../../../shared/util/resource_save_path_provider.dart';
import '../../../shared/util/uuid_factory.dart';
import '../model/download_task.dart';
import '../model/file_type.dart';

@lazySingleton
class DownloadTaskMapper {
  DownloadTaskMapper(
    this._uuidFactory,
  );

  final UuidFactory _uuidFactory;

  Future<DownloadTask?> userAudioToDownloadTask(
    UserAudio userAudio, {
    DownloadTaskSyncAudioPayload? syncAudioPayload,
  }) async {
    final uri = tryMap(userAudio.audio?.path, (path) => Uri.tryParse(assembleResourceUrl(path)));
    if (uri == null) {
      return null;
    }

    const fileType = FileType.audioMp3;

    final savePath = await _getSavePath(fileType);

    return DownloadTask(
      id: _uuidFactory.generate(),
      savePath: savePath,
      uri: uri,
      progress: 0,
      speedInKbs: 0,
      state: DownloadTaskState.idle,
      fileType: fileType,
      payload: DownloadTaskPayload(
        userAudio: userAudio,
      ),
    );
  }

  Future<String> _getSavePath(FileType fileType) async {
    switch (fileType) {
      case FileType.audioMp3:
        final dirPath = await ResourceSavePathProvider.getAudioMp3SavePath();
        final fileName = _uuidFactory.generate();

        return '$dirPath/$fileName.mp3';
    }
  }
}
