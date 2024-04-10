import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audio/model/audio.dart';

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
    required List<Audio>? audios,
  }) = _Playlist;
}
