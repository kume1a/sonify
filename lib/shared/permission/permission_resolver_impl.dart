import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ui/status_dialog.dart';
import 'permission_manager.dart';
import 'permission_resolver.dart';

@LazySingleton(as: PermissionResolver)
class PermissionResolverImpl implements PermissionResolver {
  PermissionResolverImpl(
    this._permissionManager,
  );

  final PermissionManager _permissionManager;

  @override
  Future<bool> resolveStoragePermission() async {
    final bool isGranted = await _permissionManager.isStoragePermissionGranted();

    if (isGranted) {
      return true;
    }

    final status = await _permissionManager.requestStoragePermission();

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        GlobalNavigator.dialog(
          StatusDialog(
            content: (l) => l.storagePermissionDenied,
            buttonLabel: (l) => l.openSettings,
            onPressed: _permissionManager.openPermissionSettings,
          ),
        );
        return false;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
        GlobalNavigator.dialog(
          StatusDialog(
            content: (l) => l.storagePermissionDenied,
            buttonLabel: (l) => l.ok,
          ),
        );
        return false;
    }
  }
}
