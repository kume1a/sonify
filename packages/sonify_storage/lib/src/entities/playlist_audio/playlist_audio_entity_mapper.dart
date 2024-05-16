import '../../db/tables.dart';
import 'playlist_audio_entity.dart';

class PlaylistAudioEntityMapper {
  PlaylistAudioEntity mapToEntity(Map<String, dynamic> m) {
    return PlaylistAudioEntity(
      id: m[PlaylistAudio_.id] as int?,
      createdAtMillis: m[PlaylistAudio_.createdAtMillis] as int?,
      audioId: m[PlaylistAudio_.audioId] as String?,
      playlistId: m[PlaylistAudio_.playlistId] as String?,
    );
  }

  PlaylistAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[PlaylistAudio_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return PlaylistAudioEntity(
      id: id,
      createdAtMillis: m[PlaylistAudio_.joinedCreatedAtMillis] as int?,
      audioId: m[PlaylistAudio_.joinedAudioId] as String?,
      playlistId: m[PlaylistAudio_.joinedPlaylistId] as String?,
    );
  }

  Map<String, dynamic> entityToMap(PlaylistAudioEntity e) {
    return {
      PlaylistAudio_.id: e.id,
      PlaylistAudio_.createdAtMillis: e.createdAtMillis,
      PlaylistAudio_.audioId: e.audioId,
      PlaylistAudio_.playlistId: e.playlistId,
    };
  }
}
