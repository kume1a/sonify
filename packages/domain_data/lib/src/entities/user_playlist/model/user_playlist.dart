import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_playlist.freezed.dart';

@freezed
class UserPlaylist with _$UserPlaylist {
  const factory UserPlaylist({
    required String? id,
    required DateTime? createdAt,
    required String userId,
    required String playlistId,
    required bool isSpotifySavedPlaylist,
  }) = _UserPlaylist;
}
