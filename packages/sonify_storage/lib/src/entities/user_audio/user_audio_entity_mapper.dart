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
      id: m[UserAudio_.id] as String?,
      createdAtMillis: m[UserAudio_.createdAtMillis] as int?,
      userId: m[UserAudio_.userId] as String?,
      audioId: m[UserAudio_.audioId] as String?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  UserAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[UserAudio_.joinedId] as String?;
    if (id == null) {
      return null;
    }

    return UserAudioEntity(
      id: id,
      createdAtMillis: m[UserAudio_.joinedCreatedAtMillis] as int?,
      userId: m[UserAudio_.joinedUserId] as String?,
      audioId: m[UserAudio_.joinedAudioId] as String?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(UserAudioEntity e) {
    return {
      UserAudio_.id: e.id,
      UserAudio_.createdAtMillis: e.createdAtMillis,
      UserAudio_.userId: e.userId,
      UserAudio_.audioId: e.audioId,
    };
  }
}
