import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_audio.freezed.dart';

@freezed
class EventAudio with _$EventAudio {
  const factory EventAudio.downloaded(Audio audio) = _downloaded;
}
