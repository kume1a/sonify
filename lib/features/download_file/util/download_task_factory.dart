import '../../../entities/remote_audio_file/model/remote_audio_file.dart';
import '../model/download_task.dart';

abstract interface class DownloadTaskFactory {
  Future<DownloadTask> fromRemoteAudioFile(RemoteAudioFile remoteAudioFile);
}
