import '../../shared/wrapped.dart';

class AudioLikeEntity {
  AudioLikeEntity({
    required this.id,
    required this.bAudioId,
    required this.bUserId,
  });

  final int? id;
  final String? bAudioId;
  final String? bUserId;

  AudioLikeEntity copyWith({
    Wrapped<int?>? id,
    Wrapped<String?>? bAudioId,
    Wrapped<String?>? bUserId,
  }) {
    return AudioLikeEntity(
      id: id?.value ?? this.id,
      bAudioId: bAudioId?.value ?? this.bAudioId,
      bUserId: bUserId?.value ?? this.bUserId,
    );
  }
}
