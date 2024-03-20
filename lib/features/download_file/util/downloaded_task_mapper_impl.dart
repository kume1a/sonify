import 'package:injectable/injectable.dart';

import '../../../entities/audio/model/local_audio_file.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';
import 'downloaded_task_mapper.dart';

@LazySingleton(as: DownloadedTaskMapper)
class DownloadedTaskMapperImpl implements DownloadedTaskMapper {
  @override
  DownloadedTask fromDownloadTask(
    DownloadTask downloadTask,
    String? thumbnailSavePath,
  ) {
    final DownloadedTaskPayload payload;
    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        final remoteAudioFile = downloadTask.payload.remoteAudioFile;

        payload = DownloadedTaskPayload(
          localAudioFile: LocalAudioFile(
            id: -1,
            author: remoteAudioFile?.author ?? '',
            thumbnailPath: thumbnailSavePath,
            path: downloadTask.savePath,
            sizeInBytes: remoteAudioFile?.sizeInBytes ?? 0,
            title: remoteAudioFile?.title ?? '',
            duration: remoteAudioFile?.duration ?? Duration.zero,
            userId: remoteAudioFile?.userId ?? '',
            youtubeVideoId: remoteAudioFile?.youtubeVideoId ?? '',
          ),
        );
        break;
      case FileType.videoMp4:
        payload = const DownloadedTaskPayload(); // TODO add payload
        break;
    }

    return DownloadedTask(
      savePath: downloadTask.savePath,
      fileType: downloadTask.fileType,
      payload: payload,
    );
  }
}
