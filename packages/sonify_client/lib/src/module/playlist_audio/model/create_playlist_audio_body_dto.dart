import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_playlist_audio_body_dto.g.dart';

part 'create_playlist_audio_body_dto.freezed.dart';

@freezed
class CreatePlaylistAudioBodyDto with _$CreatePlaylistAudioBodyDto {
  const factory CreatePlaylistAudioBodyDto({
    required String playlistId,
    required String audioId,
  }) = _CreatePlaylistAudioBodyDto;

  factory CreatePlaylistAudioBodyDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePlaylistAudioBodyDtoFromJson(json);
}
