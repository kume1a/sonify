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

  Future<DownloadTask> fromUserAudio(UserAudio userAudio) async {
    const fileType = FileType.audioMp3;

    final savePath = await _getSavePath(fileType);

    return DownloadTask(
      savePath: savePath,
      uri: Uri.parse(assembleResourceUrl(userAudio.audio.path)),
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
    String extension = switch (fileType) {
      FileType.audioMp3 => 'mp3',
      FileType.videoMp4 => 'mp4',
    };

    final dirPath = await ResourceSavePathProvider.getAudioMp3SavePath();
    final fileName = _uuidFactory.generate();

    return '$dirPath/$fileName.$extension';
  }
}
