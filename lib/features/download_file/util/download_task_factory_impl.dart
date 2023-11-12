import 'package:injectable/injectable.dart';

import '../../../entities/audio/model/remote_audio_file.dart';
import '../../../shared/util/resource_save_path_provider.dart';
import '../../../shared/util/uuid_factory.dart';
import '../model/download_task.dart';
import '../model/file_type.dart';
import 'download_task_factory.dart';

@LazySingleton(as: DownloadTaskFactory)
class DownloadTaskFactoryImpl implements DownloadTaskFactory {
  DownloadTaskFactoryImpl(
    this._uuidFactory,
  );

  final UuidFactory _uuidFactory;

  @override
  Future<DownloadTask> fromRemoteAudioFile(RemoteAudioFile remoteAudioFile) async {
    const fileType = FileType.audioMp3;

    final savePath = await _getSavePath(fileType);

    return DownloadTask(
      savePath: savePath,
      uri: remoteAudioFile.uri,
      progress: 0,
      state: DownloadTaskState.idle,
      fileType: fileType,
      payload: DownloadTaskPayload(
        remoteAudioFile: remoteAudioFile,
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
