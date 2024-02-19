import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../model/audio.dart';
import '../model/audio_dto.dart';

class AudioMapper {
  Audio dtoToModel(AudioDto dto) {
    return Audio(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      updatedAt: tryMapDate(dto.updatedAt),
      title: dto.title ?? '',
      duration: dto.duration ?? 0,
      path: dto.path ?? '',
      author: dto.author ?? '',
      userId: dto.userId ?? kInvalidId,
    );
  }
}
