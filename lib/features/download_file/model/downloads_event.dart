import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/audio/model/remote_audio_file.dart';

part 'downloads_event.freezed.dart';

@freezed
class DownloadsEvent with _$DownloadsEvent {
  const factory DownloadsEvent.enqueueRemoteAudioFile(
    RemoteAudioFile remoteAudioFile,
  ) = _enqueueRemoteAudioFile;
}
