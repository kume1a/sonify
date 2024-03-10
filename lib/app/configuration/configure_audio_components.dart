import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../di/register_dependencies.dart';

Future<void> configureAudioComponents() async {
  await getIt<ConfigureAudioSession>().call();
}

@lazySingleton
class ConfigureAudioSession {
  ConfigureAudioSession(
    this._audioSession,
  );

  final AudioSession _audioSession;

  Future<void> call() async {
    await _audioSession.configure(const AudioSessionConfiguration.music());

    _audioSession.becomingNoisyEventStream.listen((_) {
      Logger.root.info('User unplugged headphones');
    });

    _audioSession.devicesChangedEventStream.listen((event) {
      Logger.root.info('Devices added:   ${event.devicesAdded}');
      Logger.root.info('Devices removed: ${event.devicesRemoved}');
    });
  }
}
