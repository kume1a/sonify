import '../../../shared/constant.dart';
import '../model/user_audio.dart';
import '../model/user_audio_dto.dart';
import 'audio_mapper.dart';

class UserAudioMapper {
  UserAudioMapper(
    this._audioMapper,
  );

  final AudioMapper _audioMapper;

  UserAudio dtoToModel(UserAudioDto dto) {
    return UserAudio(
      userId: dto.userId ?? kInvalidId,
      audioId: dto.audioId ?? kInvalidId,
      audio: _audioMapper.dtoToModel(dto.audio!),
    );
  }
}
