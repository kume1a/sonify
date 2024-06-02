import '../../shared/wrapped.dart';
import '../audio/audio_entity.dart';

class PlaylistAudioEntity {
  PlaylistAudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.playlistId,
    required this.audioId,
    required this.audio,
  });

  final String? id;
  final int? createdAtMillis;
  final String? playlistId;
  final String? audioId;

  final AudioEntity? audio;

  PlaylistAudioEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? playlistId,
    Wrapped<String?>? audioId,
    Wrapped<AudioEntity?>? audio,
  }) {
    return PlaylistAudioEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      playlistId: playlistId?.value ?? this.playlistId,
      audioId: audioId?.value ?? this.audioId,
      audio: audio?.value ?? this.audio,
    );
  }
}
