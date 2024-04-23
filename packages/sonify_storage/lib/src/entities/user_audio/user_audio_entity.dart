import '../../shared/wrapped.dart';
import '../audio/audio_entity.dart';

class UserAudioEntity {
  UserAudioEntity({
    required this.id,
    required this.bCreatedAtMillis,
    required this.bUserId,
    required this.bAudioId,
    required this.audioId,
    required this.audio,
  });

  final int? id;
  final int? bCreatedAtMillis;
  final String? bUserId;
  final String? bAudioId;
  final int? audioId;
  final AudioEntity? audio;

  UserAudioEntity copyWith({
    Wrapped<int?>? id,
    Wrapped<int?>? bCreatedAtMillis,
    Wrapped<String?>? bUserId,
    Wrapped<String?>? bAudioId,
    Wrapped<int?>? audioId,
    Wrapped<AudioEntity?>? audio,
  }) {
    return UserAudioEntity(
      id: id?.value ?? this.id,
      bCreatedAtMillis: bCreatedAtMillis?.value ?? this.bCreatedAtMillis,
      bUserId: bUserId?.value ?? this.bUserId,
      bAudioId: bAudioId?.value ?? this.bAudioId,
      audioId: audioId?.value ?? this.audioId,
      audio: audio?.value ?? this.audio,
    );
  }
}
