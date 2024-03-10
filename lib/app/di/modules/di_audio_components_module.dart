import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';

import '../../../features/play_audio/api/app_audio_handler_factory.dart';

@module
abstract class DiAudioComponentsModule {
  @lazySingleton
  @preResolve
  Future<AudioSession> audioSession() {
    return AudioSession.instance;
  }

  @lazySingleton
  @preResolve
  Future<AudioHandler> appAudioHandler(AppAudioHandlerFactory appAudioHandlerFactory) {
    return appAudioHandlerFactory.create();
  }
}
