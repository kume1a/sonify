import '../model/audio.dart';
import '../model/user_audio.dart';

abstract interface class AudioLocalRepository {
  Future<List<UserAudio>> getAllByUserId(String userId);

  Future<Audio?> getById(int id);

  Future<UserAudio?> save(UserAudio audio);

  Future<int> deleteUserAudioJoinsByIds(List<int> ids);
}
