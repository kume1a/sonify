import '../model/audio.dart';

abstract interface class AudioLocalRepository {
  Future<List<Audio>> getAllByUserId(String userId);

  Future<Audio?> getById(int id);

  Future<Audio> save(Audio audio);
}
