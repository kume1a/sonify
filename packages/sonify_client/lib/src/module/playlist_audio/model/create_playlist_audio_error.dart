import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_playlist_audio_error.freezed.dart';

@freezed
class CreatePlaylistAudioError with _$CreatePlaylistAudioError {
  const factory CreatePlaylistAudioError.unknown() = _unknown;

  const factory CreatePlaylistAudioError.network() = _network;

  const factory CreatePlaylistAudioError.alreadyExists() = _alreadyExists;
}
