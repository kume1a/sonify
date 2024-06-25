import 'package:flutter/material.dart';

import '../../app/intl/app_localizations.dart';
import '../values/app_theme_extension.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          l.search,
          style: TextStyle(
            color: theme.appThemeExtension?.elSecondary,
          ),
        ),
      ),
    );
  }
}
