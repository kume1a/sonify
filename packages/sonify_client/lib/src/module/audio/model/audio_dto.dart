import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audiolike/model/audio_like_dto.dart';
import '../../hidden_user_audio/model/hidden_user_audio_dto.dart';

part 'audio_dto.g.dart';

part 'audio_dto.freezed.dart';

@freezed
class AudioDto with _$AudioDto {
  const factory AudioDto({
    String? id,
    String? createdAt,
    String? title,
    int? durationMs,
    String? path,
    String? author,
    String? userId,
    int? sizeBytes,
    String? youtubeVideoId,
    String? thumbnailPath,
    String? thumbnailUrl,
    String? spotifyId,
    AudioLikeDto? audioLike,
    HiddenUserAudioDto? hiddenUserAudio,
  }) = _AudioDto;

  factory AudioDto.fromJson(Map<String, dynamic> json) => _$AudioDtoFromJson(json);
}
