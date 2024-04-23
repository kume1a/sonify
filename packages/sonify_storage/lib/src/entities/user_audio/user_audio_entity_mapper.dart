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
      id: m[UserAudioEntity_.id] as int?,
      bCreatedAtMillis: m[UserAudioEntity_.bCreatedAtMillis] as int?,
      bUserId: m[UserAudioEntity_.bUserId] as String?,
      bAudioId: m[UserAudioEntity_.bAudioId] as String?,
      audioId: m[UserAudioEntity_.audioId] as int?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  UserAudioEntity? joinedMapToEntity(Map<String, dynamic> m) {
    final id = m[UserAudioEntity_.joinedId] as int?;
    if (id == null) {
      return null;
    }

    return UserAudioEntity(
      id: id,
      bCreatedAtMillis: m[UserAudioEntity_.joinedBCreatedAtMillis] as int?,
      bUserId: m[UserAudioEntity_.joinedBUserId] as String?,
      bAudioId: m[UserAudioEntity_.joinedBAudioId] as String?,
      audioId: m[UserAudioEntity_.joinedAudioId] as int?,
      audio: _audioEntityMapper.joinedMapToEntity(m),
    );
  }

  Map<String, dynamic> entityToMap(UserAudioEntity e) {
    return {
      UserAudioEntity_.id: e.id,
      UserAudioEntity_.bCreatedAtMillis: e.bCreatedAtMillis,
      UserAudioEntity_.bUserId: e.bUserId,
      UserAudioEntity_.bAudioId: e.bAudioId,
      UserAudioEntity_.audioId: e.audioId,
    };
  }
}
