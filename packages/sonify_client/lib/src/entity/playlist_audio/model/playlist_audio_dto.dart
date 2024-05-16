import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_audio_dto.g.dart';

part 'playlist_audio_dto.freezed.dart';

@freezed
class PlaylistAudioDto with _$PlaylistAudioDto {
  const factory PlaylistAudioDto({
    String? id,
    String? createdAt,
    String? playlistId,
    String? audioId,
  }) = _PlaylistAudioDto;

  factory PlaylistAudioDto.fromJson(Map<String, dynamic> json) => _$PlaylistAudioDtoFromJson(json);
}
