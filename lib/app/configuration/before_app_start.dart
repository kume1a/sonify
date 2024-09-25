import '../../entities/server_time/api/get_server_time.dart';
import '../../shared/util/system_ui_manager.dart';
import '../di/register_dependencies.dart';
import 'configure_audio_components.dart';
import 'configure_secure_storage.dart';

Future<void> beforeAppStart() async {
  final systemUiManager = getIt<SystemUiManager>();
  final configureSecureStorage = getIt<ConfigureSecureStorage>();
  final getServerTime = getIt<GetServerTime>();

  await Future.wait([
    configureAudioComponents(),
    systemUiManager.lockPortraitOrientation(),
    configureSecureStorage(),
  ]);

  // don't await to avoid long startup time.
  getServerTime();
}
