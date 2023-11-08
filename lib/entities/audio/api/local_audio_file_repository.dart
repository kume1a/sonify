import '../model/local_audio_file.dart';

abstract interface class LocalAudioFileRepository {
  Future<List<LocalAudioFile>> getAll();

  Future<void> save(LocalAudioFile localAudioFile);
}
