import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audio/model/audio_dto.dart';

part 'user_audio_dto.g.dart';

part 'user_audio_dto.freezed.dart';

@freezed
class UserAudioDto with _$UserAudioDto {
  const factory UserAudioDto({
    String? id,
    String? createdAt,
    String? userId,
    String? audioId,
    AudioDto? audio,
  }) = _UserAudioDto;

  factory UserAudioDto.fromJson(Map<String, dynamic> json) => _$UserAudioDtoFromJson(json);
}
