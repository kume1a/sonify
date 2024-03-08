import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';

import '../../../features/play_audio/api/app_audio_handler.dart';
import '../../../features/play_audio/api/app_audio_handler_factory.dart';

abstract class DiAudioComponentsModule {
  @lazySingleton
  @preResolve
  Future<AudioSession> get audioSession => AudioSession.instance;

  @preResolve
  @lazySingleton
  Future<AppAudioHandler> appAudioHandler(AppAudioHandlerFactory appAudioHandlerFactory) {
    return appAudioHandlerFactory.create();
  }
}
