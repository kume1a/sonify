import '../../shared/wrapped.dart';

class HiddenUserAudioEntity {
  HiddenUserAudioEntity({
    required this.id,
    required this.createdAtMillis,
    required this.userId,
    required this.audioId,
  });

  final String? id;
  final int? createdAtMillis;
  final String? userId;
  final String? audioId;

  HiddenUserAudioEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? userId,
    Wrapped<String?>? audioId,
  }) {
    return HiddenUserAudioEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      userId: userId?.value ?? this.userId,
      audioId: audioId?.value ?? this.audioId,
    );
  }
}
