import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../../app/intl/app_localizations.dart';

@lazySingleton
class DialogManager {
  Future<bool> showConfirmationDialog({
    required String caption,
    String? title,
    String? positiveLabel,
    String? negativeLabel,
  }) async {
    final bool? didConfirm = await GlobalNavigator.dialog<bool>(
      ConfirmationDialog(
        strings: (c) {
          final l = AppLocalizations.of(c);

          return ConfirmationDialogStrings(
            title: title,
            caption: caption,
            positiveLabel: positiveLabel ?? l.confirm,
            negativeLabel: negativeLabel ?? l.nevermind,
          );
        },
      ),
    );

    return didConfirm ?? false;
  }

  Future<void> showStatusDialog({
    required String content,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) {
    return GlobalNavigator.dialog<void>(
      StatusDialog(
        onPressed: onPressed,
        strings: (BuildContext c) {
          final l = AppLocalizations.of(c);

          return StatusDialogStrings(
            content: content,
            buttonLabel: buttonLabel ?? l.ok,
          );
        },
      ),
    );
  }
}
