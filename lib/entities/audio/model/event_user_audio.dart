import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_user_audio.freezed.dart';

@freezed
class EventUserAudio with _$EventUserAudio {
  const factory EventUserAudio.downloaded(UserAudio userAudio) = _downloaded;
}
