import 'package:freezed_annotation/freezed_annotation.dart';

part 'hidden_user_audio.freezed.dart';

@freezed
class HiddenUserAudio with _$HiddenUserAudio {
  const factory HiddenUserAudio({
    required String id,
    required DateTime? createdAt,
    required String audioId,
    required String userId,
  }) = _HiddenUserAudio;
}
