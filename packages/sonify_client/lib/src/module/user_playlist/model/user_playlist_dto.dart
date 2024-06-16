import 'package:freezed_annotation/freezed_annotation.dart';

import '../../playlist/model/playlist_dto.dart';

part 'user_playlist_dto.g.dart';

part 'user_playlist_dto.freezed.dart';

@freezed
class UserPlaylistDto with _$UserPlaylistDto {
  const factory UserPlaylistDto({
    String? id,
    String? createdAt,
    String? userId,
    String? playlistId,
    bool? isSpotifySavedPlaylist,
    PlaylistDto? playlist,
  }) = _UserPlaylistDto;

  factory UserPlaylistDto.fromJson(Map<String, dynamic> json) => _$UserPlaylistDtoFromJson(json);
}
