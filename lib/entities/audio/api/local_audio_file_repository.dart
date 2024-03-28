import '../model/local_audio_file.dart';

abstract interface class LocalAudioFileRepository {
  Future<List<LocalAudioFile>> getAllByUserId(String userId);

  Future<LocalAudioFile?> getById(int id);

  Future<LocalAudioFile> save(LocalAudioFile localAudioFile);
}
