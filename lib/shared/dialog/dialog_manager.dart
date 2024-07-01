import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../../app/intl/app_localizations.dart';
import '../typedefs.dart';

@lazySingleton
class DialogManager {
  Future<bool> showConfirmationDialog({
    required LocalizedStringResolver caption,
    LocalizedStringResolver? title,
    LocalizedStringResolver? positiveLabel,
    LocalizedStringResolver? negativeLabel,
  }) async {
    final bool? didConfirm = await GlobalNavigator.dialog<bool>(
      ConfirmationDialog(
        strings: (c) {
          final l = AppLocalizations.of(c);

          return ConfirmationDialogStrings(
            title: title?.call(l),
            caption: caption(l),
            positiveLabel: positiveLabel?.call(l) ?? l.confirm,
            negativeLabel: negativeLabel?.call(l) ?? l.nevermind,
          );
        },
      ),
    );

    return didConfirm ?? false;
  }

  Future<void> showStatusDialog({
    required LocalizedStringResolver content,
    LocalizedStringResolver? buttonLabel,
    VoidCallback? onPressed,
  }) {
    return GlobalNavigator.dialog<void>(
      StatusDialog(
        onPressed: onPressed,
        strings: (c) {
          final l = AppLocalizations.of(c);

          return StatusDialogStrings(
            content: content(l),
            buttonLabel: buttonLabel?.call(l) ?? l.ok,
          );
        },
      ),
    );
  }
}
