import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_audio.freezed.dart';

@freezed
class PlaylistAudio with _$PlaylistAudio {
  const factory PlaylistAudio({
    required String? id,
    required DateTime? createdAt,
    required String audioId,
    required String playlistId,
  }) = _PlaylistAudio;
}
