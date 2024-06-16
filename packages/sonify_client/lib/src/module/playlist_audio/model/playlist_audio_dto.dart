import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audio/model/audio_dto.dart';

part 'playlist_audio_dto.g.dart';

part 'playlist_audio_dto.freezed.dart';

@freezed
class PlaylistAudioDto with _$PlaylistAudioDto {
  const factory PlaylistAudioDto({
    String? id,
    String? createdAt,
    String? playlistId,
    String? audioId,
    AudioDto? audio,
  }) = _PlaylistAudioDto;

  factory PlaylistAudioDto.fromJson(Map<String, dynamic> json) => _$PlaylistAudioDtoFromJson(json);
}
