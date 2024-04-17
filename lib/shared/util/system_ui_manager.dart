import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract class SystemUiManager {
  Future<void> showSystemUi();

  Future<void> hideSystemUi();

  Future<void> lockPortraitOrientation();

  Future<void> lockLandscapeOrientation();

  Future<void> disableOrientationLock();
}

@LazySingleton(as: SystemUiManager)
class DefaultSystemUiManager implements SystemUiManager {
  @override
  Future<void> showSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay>[
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  @override
  Future<void> hideSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Future<void> lockPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
  }

  @override
  Future<void> lockLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Future<void> disableOrientationLock() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[]);
  }
}
