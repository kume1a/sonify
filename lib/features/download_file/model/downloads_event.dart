import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sonify_client/sonify_client.dart';

part 'downloads_event.freezed.dart';

@freezed
class DownloadsEvent with _$DownloadsEvent {
  const factory DownloadsEvent.enqueueUserAudio(
    UserAudio userAudio,
  ) = _enqueueUserAudio;
}
