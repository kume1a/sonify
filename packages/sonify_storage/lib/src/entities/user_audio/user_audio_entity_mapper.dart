import '../../db/tables.dart';
import '../audio/audio_entity_mapper.dart';
import 'user_audio_entity.dart';

class UserAudioEntityMapper {
  UserAudioEntityMapper(
    this._audioEntityMapper,
  );

  final AudioEntityMapper _audioEntityMapper;

  UserAudioEntity mapToEntity(Map<String, dynamic> m) {
    return UserAudioEntity(
      id: m[UserAudio_.id] as int?,
      bCreatedAtMillis: m[UserAudio_.bCreatedAtMillis] as int?,
      bUserId: m[UserAudio_.bUserId] as String?,
      bAudioId: m[UserAudio_.bAudioId] as String?,
      audioId: m[UserAudio_.audioId] as int?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  UserAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[UserAudio_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return UserAudioEntity(
      id: id,
      bCreatedAtMillis: m[UserAudio_.joinedBCreatedAtMillis] as int?,
      bUserId: m[UserAudio_.joinedBUserId] as String?,
      bAudioId: m[UserAudio_.joinedBAudioId] as String?,
      audioId: m[UserAudio_.joinedAudioId] as int?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(UserAudioEntity e) {
    return {
      UserAudio_.id: e.id,
      UserAudio_.bCreatedAtMillis: e.bCreatedAtMillis,
      UserAudio_.bUserId: e.bUserId,
      UserAudio_.bAudioId: e.bAudioId,
      UserAudio_.audioId: e.audioId,
    };
  }
}
