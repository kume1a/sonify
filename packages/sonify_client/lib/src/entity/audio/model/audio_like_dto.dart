import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_like_dto.g.dart';

part 'audio_like_dto.freezed.dart';

@freezed
class AudioLikeDto with _$AudioLikeDto {
  const factory AudioLikeDto({
    String? id,
    String? userId,
    String? audioId,
  }) = _AudioLikeDto;

  factory AudioLikeDto.fromJson(Map<String, dynamic> json) => _$AudioLikeDtoFromJson(json);
}
