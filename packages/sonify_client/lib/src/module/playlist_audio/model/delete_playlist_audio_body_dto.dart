import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_playlist_audio_body_dto.g.dart';

part 'delete_playlist_audio_body_dto.freezed.dart';

@freezed
class DeletePlaylistAudioBodyDto with _$DeletePlaylistAudioBodyDto {
  const factory DeletePlaylistAudioBodyDto({
    required String playlistId,
    required String audioId,
  }) = _DeletePlaylistAudioBodyDto;

  factory DeletePlaylistAudioBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DeletePlaylistAudioBodyDtoFromJson(json);
}
