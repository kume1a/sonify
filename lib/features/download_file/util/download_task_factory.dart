import '../../../entities/audio/model/remote_audio_file.dart';
import '../model/download_task.dart';

abstract interface class DownloadTaskFactory {
  Future<DownloadTask> fromRemoteAudioFile(RemoteAudioFile remoteAudioFile);
}
