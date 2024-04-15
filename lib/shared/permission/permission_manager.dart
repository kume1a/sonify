import 'package:permission_handler/permission_handler.dart';

abstract class PermissionManager {
  Future<bool> isStorageGranted();

  Future<PermissionStatus> requestStorage();

  Future<bool> isAudioGranted();

  Future<PermissionStatus> requestAudio();

  Future<void> openPermissionSettings();
}
