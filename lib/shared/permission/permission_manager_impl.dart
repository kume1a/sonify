import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_manager.dart';

@LazySingleton(as: PermissionManager)
class PermissionManagerImpl implements PermissionManager {
  @override
  Future<bool> isStoragePermissionGranted() async => Permission.storage.isGranted;

  @override
  Future<PermissionStatus> requestStoragePermission() async => Permission.storage.request();

  @override
  Future<void> openPermissionSettings() => openAppSettings();

  @override
  Future<bool> isCameraPermissionGranted() => Permission.camera.isGranted;

  @override
  Future<PermissionStatus> requestCameraPermission() => Permission.storage.request();
}
