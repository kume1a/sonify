import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../model/audio.dart';
import '../model/audio_dto.dart';

class AudioMapper {
  Audio dtoToModel(AudioDto dto) {
    return Audio(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      title: dto.title ?? '',
      durationMs: dto.durationMs ?? 0,
      path: dto.path ?? '',
      author: dto.author ?? '',
      sizeBytes: dto.sizeBytes ?? 0,
      thumbnailPath: dto.thumbnailPath,
      youtubeVideoId: dto.youtubeVideoId,
      thumbnailUrl: dto.thumbnailUrl,
      spotifyId: dto.spotifyId,
    );
  }
}
