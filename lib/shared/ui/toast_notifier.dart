import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

import '../../app/intl/get_static_localizations.dart';
import '../typedefs.dart';
import 'static_theme.dart';

@lazySingleton
final class ToastNotifier {
  void warning({
    LocalizedStringResolver? title,
    required LocalizedStringResolver description,
  }) {
    final l = getStaticLocalizations();
    final theme = getStaticTheme();

    if (l == null || theme == null) {
      return;
    }

    final textStyle = TextStyle(
      color: theme.colorScheme.onSurface,
    );

    toastification.show(
      title: title != null ? Text(title(l), style: textStyle) : null,
      description: Text(description(l), style: textStyle),
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      closeButtonShowType: CloseButtonShowType.none,
      backgroundColor: theme.colorScheme.surface,
      showProgressBar: false,
      borderSide: BorderSide(color: theme.colorScheme.secondaryContainer),
      primaryColor: theme.colorScheme.onSurface,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
    );
  }
}
