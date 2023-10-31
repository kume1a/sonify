import 'package:flutter/material.dart';

import 'palette.dart';

abstract final class AppTheme {
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.secondary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Palette.elPrimary,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
