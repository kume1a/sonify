import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_manager.dart';

@LazySingleton(as: PermissionManager)
class PermissionManagerImpl implements PermissionManager {
  @override
  Future<bool> isStorageGranted() => Permission.storage.isGranted;

  @override
  Future<PermissionStatus> requestStorage() => Permission.storage.request();

  @override
  Future<bool> isAudioGranted() => Permission.audio.isGranted;

  @override
  Future<PermissionStatus> requestAudio() => Permission.audio.request();

  @override
  Future<void> openPermissionSettings() => openAppSettings();
}
