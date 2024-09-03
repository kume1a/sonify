import 'package:freezed_annotation/freezed_annotation.dart';

part 'hidden_user_audio_dto.g.dart';

part 'hidden_user_audio_dto.freezed.dart';

@freezed
class HiddenUserAudioDto with _$HiddenUserAudioDto {
  const factory HiddenUserAudioDto({
    String? id,
    String? createdAt,
    String? userId,
    String? audioId,
  }) = _HiddenUserAudioDto;

  factory HiddenUserAudioDto.fromJson(Map<String, dynamic> json) => _$HiddenUserAudioDtoFromJson(json);
}
