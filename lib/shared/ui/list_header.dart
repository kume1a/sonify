import 'package:flutter/material.dart';

import '../../app/intl/app_localizations.dart';
import '../values/app_theme_extension.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.text,
    this.onViewAllPressed,
  });

  final String text;
  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          if (onViewAllPressed != null)
            GestureDetector(
              onTap: onViewAllPressed,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
                child: Text(
                  l.viewAll,
                  style: TextStyle(fontSize: 12, color: theme.appThemeExtension?.elSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
