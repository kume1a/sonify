import 'package:freezed_annotation/freezed_annotation.dart';

import '../../playlist_audio/model/playlist_audio.dart';
import 'process_status.dart';

part 'playlist.freezed.dart';

@freezed
class Playlist with _$Playlist {
  const factory Playlist({
    required String id,
    required DateTime? createdAt,
    required String name,
    required String? thumbnailPath,
    required String? thumbnailUrl,
    required String? spotifyId,
    required ProcessStatus? audioImportStatus,
    required int audioCount,
    required int totalAudioCount,
    required List<PlaylistAudio>? playlistAudios,
  }) = _Playlist;
}
