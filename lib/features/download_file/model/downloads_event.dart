import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'downloads_event.freezed.dart';

@freezed
class DownloadsEvent with _$DownloadsEvent {
  const factory DownloadsEvent.enqueueUserAudio(UserAudio userAudio) = _enqueueUserAudio;

  const factory DownloadsEvent.enqueuePlaylistAudio(PlaylistAudio playlistAudio) = _enqueuePlaylistAudio;
}
