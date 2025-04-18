import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_play_audio.freezed.dart';

@freezed
class EventPlayAudio with _$EventPlayAudio {
  const factory EventPlayAudio.reloadNowPlayingPlaylist({
    @Default(false) bool allowLocalAudioPlaylistReload,
  }) = _reloadNowPlayingPlaylist;
}
