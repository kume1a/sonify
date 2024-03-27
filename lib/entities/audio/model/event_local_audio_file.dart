import 'package:freezed_annotation/freezed_annotation.dart';

import 'local_audio_file.dart';

part 'event_local_audio_file.freezed.dart';

@freezed
class EventLocalAudioFile with _$EventLocalAudioFile {
  const factory EventLocalAudioFile.downloaded(LocalAudioFile localAudioFile) = _downloaded;
}
