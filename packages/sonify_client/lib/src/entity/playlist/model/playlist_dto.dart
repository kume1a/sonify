import 'package:freezed_annotation/freezed_annotation.dart';

import '../../playlist_audio/model/playlist_audio_dto.dart';

part 'playlist_dto.g.dart';

part 'playlist_dto.freezed.dart';

@freezed
class PlaylistDto with _$PlaylistDto {
  const factory PlaylistDto({
    String? id,
    String? createdAt,
    String? name,
    String? thumbnailPath,
    String? thumbnailUrl,
    String? spotifyId,
    String? audioImportStatus,
    int? audioCount,
    int? totalAudioCount,
    List<PlaylistAudioDto>? audios,
  }) = _PlaylistDto;

  factory PlaylistDto.fromJson(Map<String, dynamic> json) => _$PlaylistDtoFromJson(json);
}
