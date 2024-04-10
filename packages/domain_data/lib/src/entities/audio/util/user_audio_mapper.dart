import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../model/user_audio.dart';
import 'audio_mapper.dart';

class UserAudioMapper {
  UserAudioMapper(
    this._audioMapper,
  );

  final AudioMapper _audioMapper;

  UserAudio fromDto(UserAudioDto dto) {
    return UserAudio(
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
      audio: _audioMapper.fromDto(dto.audio!),
    );
  }
}
