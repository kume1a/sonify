import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_playlist_audio.freezed.dart';

@freezed
class EventPlaylistAudio with _$EventPlaylistAudio {
  const factory EventPlaylistAudio.downloaded(PlaylistAudio playlistAudio) = _downloaded;
}
