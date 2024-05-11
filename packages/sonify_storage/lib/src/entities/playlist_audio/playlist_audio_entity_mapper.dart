import '../../db/tables.dart';
import 'playlist_audio_entity.dart';

class PlaylistAudioEntityMapper {
  PlaylistAudioEntity mapToEntity(Map<String, dynamic> m) {
    return PlaylistAudioEntity(
      id: m[PlaylistAudio_.id] as int?,
      bCreatedAtMillis: m[PlaylistAudio_.bCreatedAtMillis] as int?,
      bAudioId: m[PlaylistAudio_.bAudioId] as String?,
      bPlaylistId: m[PlaylistAudio_.bPlaylistId] as String?,
    );
  }

  PlaylistAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[PlaylistAudio_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return PlaylistAudioEntity(
      id: id,
      bCreatedAtMillis: m[PlaylistAudio_.joinedBCreatedAtMillis] as int?,
      bAudioId: m[PlaylistAudio_.joinedBAudioId] as String?,
      bPlaylistId: m[PlaylistAudio_.joinedBPlaylistId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(PlaylistAudioEntity e) {
    return {
      PlaylistAudio_.id: e.id,
      PlaylistAudio_.bCreatedAtMillis: e.bCreatedAtMillis,
      PlaylistAudio_.bAudioId: e.bAudioId,
      PlaylistAudio_.bPlaylistId: e.bPlaylistId,
    };
  }
}
