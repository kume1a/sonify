import '../../shared/wrapped.dart';

class AudioLikeEntity {
  AudioLikeEntity({
    required this.id,
    required this.audioId,
    required this.userId,
  });

  final String? id;
  final String? audioId;
  final String? userId;

  AudioLikeEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<String?>? audioId,
    Wrapped<String?>? userId,
  }) {
    return AudioLikeEntity(
      id: id?.value ?? this.id,
      audioId: audioId?.value ?? this.audioId,
      userId: userId?.value ?? this.userId,
    );
  }
}
