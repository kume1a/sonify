import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_dto.g.dart';

part 'audio_dto.freezed.dart';

@freezed
class AudioDto with _$AudioDto {
  const factory AudioDto({
    String? id,
    String? createdAt,
    String? title,
    int? duration,
    String? path,
    String? author,
    String? userId,
    int? sizeInBytes,
    String? youtubeVideoId,
    String? thumbnailPath,
  }) = _AudioDto;

  factory AudioDto.fromJson(Map<String, dynamic> json) => _$AudioDtoFromJson(json);
}
