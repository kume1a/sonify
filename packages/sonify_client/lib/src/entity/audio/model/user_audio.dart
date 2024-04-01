import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio.dart';

part 'user_audio.freezed.dart';

@freezed
class UserAudio with _$UserAudio {
  const factory UserAudio({
    required String userId,
    required String audioId,
    required Audio audio,
  }) = _UserAudio;
}
