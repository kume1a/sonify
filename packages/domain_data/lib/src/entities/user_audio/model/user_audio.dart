import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audio/model/audio.dart';

part 'user_audio.freezed.dart';

@freezed
class UserAudio with _$UserAudio {
  const factory UserAudio({
    required String? id,
    required DateTime? createdAt,
    required String userId,
    required String? audioId,
    required Audio? audio,
  }) = _UserAudio;
}
