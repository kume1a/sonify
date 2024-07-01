import 'package:common_widgets/common_widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/intl/app_localizations.dart';
import 'permission_manager.dart';
import 'permission_resolver.dart';

@LazySingleton(as: PermissionResolver)
class PermissionResolverImpl implements PermissionResolver {
  PermissionResolverImpl(
    this._permissionManager,
  );

  final PermissionManager _permissionManager;

  @override
  Future<bool> resolveAudioPermission() async {
    final bool isGranted = await _permissionManager.isStorageGranted();

    if (isGranted) {
      return true;
    }

    final status = await _permissionManager.requestAudio();

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        GlobalNavigator.dialog(
          StatusDialog(
            onPressed: _permissionManager.openPermissionSettings,
            strings: (c) {
              final l = AppLocalizations.of(c);

              return StatusDialogStrings(
                content: l.audioPermissionPermanentlyDenied,
                buttonLabel: l.openSettings,
              );
            },
          ),
        );
        return false;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
        GlobalNavigator.dialog(
          StatusDialog(
            strings: (c) {
              final l = AppLocalizations.of(c);

              return StatusDialogStrings(
                content: l.audioPermissionDenied,
                buttonLabel: l.ok,
              );
            },
          ),
        );
        return false;
    }
  }
}
