import '../../shared/wrapped.dart';
import '../audio/audio_entity.dart';

class UserAudioEntity {
  UserAudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.userId,
    required this.audioId,
    required this.audio,
  });

  final String? id;
  final int? createdAtMillis;
  final String? userId;
  final String? audioId;
  final AudioEntity? audio;

  UserAudioEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? userId,
    Wrapped<String?>? audioId,
    Wrapped<AudioEntity?>? audio,
  }) {
    return UserAudioEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      userId: userId?.value ?? this.userId,
      audioId: audioId?.value ?? this.audioId,
      audio: audio?.value ?? this.audio,
    );
  }
}
