import 'package:audio_session/audio_session.dart';
import 'package:logging/logging.dart';

class ConfigureAudioSession {
  ConfigureAudioSession(
    this._audioSession,
  );

  final AudioSession _audioSession;

  Future<void> call() async {
    await _audioSession.configure(const AudioSessionConfiguration.music());

    _audioSession.becomingNoisyEventStream.listen((_) {
      // The user unplugged the headphones, so we should pause or lower the volume.
    });

    _audioSession.devicesChangedEventStream.listen((event) {
      Logger.root.info('Devices added:   ${event.devicesAdded}');
      Logger.root.info('Devices removed: ${event.devicesRemoved}');
    });
  }
}
