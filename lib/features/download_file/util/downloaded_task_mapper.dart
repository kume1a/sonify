import 'package:injectable/injectable.dart';

import '../../../entities/audio/model/local_audio_file.dart';
import '../model/download_task.dart';
import '../model/downloaded_task.dart';
import '../model/file_type.dart';

@lazySingleton
class DownloadedTaskMapper {
  DownloadedTask fromDownloadTask(
    DownloadTask downloadTask,
    String? thumbnailSavePath,
  ) {
    final DownloadedTaskPayload payload;
    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        final userAudio = downloadTask.payload.userAudio;

        payload = DownloadedTaskPayload(
          localAudioFile: LocalAudioFile(
            id: -1,
            author: userAudio?.audio.author ?? '',
            thumbnailPath: thumbnailSavePath,
            path: downloadTask.savePath,
            sizeInBytes: userAudio?.audio.sizeBytes ?? 0,
            title: userAudio?.audio.title ?? '',
            duration: Duration(milliseconds: userAudio?.audio.durationMs ?? 0),
            userId: userAudio?.userId ?? '',
            youtubeVideoId: userAudio?.audio.youtubeVideoId ?? '',
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
