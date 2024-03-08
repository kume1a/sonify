import 'package:audio_service/audio_service.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';

import 'app_audio_handler.dart';

@lazySingleton
class AppAudioHandlerFactory implements AsyncFactory<AppAudioHandler> {
  @override
  Future<AppAudioHandler> create() {
    return AudioService.init(
      builder: () => AppAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.kume1a.sonify',
        androidNotificationChannelName: 'Music playback',
      ),
    );
  }
}
