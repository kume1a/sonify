import '../../shared/wrapped.dart';

class PlaylistAudioEntity {
  PlaylistAudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.playlistId,
    required this.audioId,
  });

  final String? id;
  final int? createdAtMillis;
  final String? playlistId;
  final String? audioId;

  PlaylistAudioEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? playlistId,
    Wrapped<String?>? audioId,
  }) {
    return PlaylistAudioEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      playlistId: playlistId?.value ?? this.playlistId,
      audioId: audioId?.value ?? this.audioId,
    );
  }
}
