import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio.dart';

part 'user_audio.freezed.dart';

@freezed
class UserAudio with _$UserAudio {
  const factory UserAudio({
    required int? localId,
    required DateTime? createdAt,
    required String userId,
    required String? audioId,
    required int? localAudioId,
    required Audio? audio,
  }) = _UserAudio;
}
