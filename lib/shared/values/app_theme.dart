import 'package:flutter/material.dart';

import 'app_theme_extension.dart';
import 'palette.dart';

final _defaultButtonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
const _defaultButtonPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

final _defaultInputBorderRadius = BorderRadius.circular(32);

abstract final class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    splashFactory: NoSplash.splashFactory,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.secondary,
      secondary: Palette.secondary,
      onSecondary: Palette.onSecondary,
      primaryContainer: Palette.primaryContainer,
      secondaryContainer: Palette.secondaryContainer,
      surface: Palette.surface,
      onSurface: Palette.onSurface,
    ),
    scaffoldBackgroundColor: Palette.surface,
    dividerColor: Palette.elSecondary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Palette.elPrimary,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      backgroundColor: Palette.primaryContainer,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: Palette.primaryContainer,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: Palette.secondaryDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.primaryContainer,
      border: OutlineInputBorder(
        borderRadius: _defaultInputBorderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _defaultInputBorderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _defaultInputBorderRadius,
        borderSide: const BorderSide(color: Palette.secondaryContainer),
      ),
      isDense: true,
      constraints: const BoxConstraints(minHeight: 1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      hintStyle: const TextStyle(fontSize: 14, color: Palette.elSecondary),
      labelStyle: const TextStyle(fontSize: 14, color: Palette.elSecondary),
      alignLabelWithHint: true,
      errorMaxLines: 2,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? Palette.secondaryLight : Palette.secondary,
        ),
        shape: WidgetStateProperty.all(_defaultButtonShape),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(Palette.secondaryDark),
        padding: WidgetStateProperty.all(_defaultButtonPadding),
        splashFactory: NoSplash.splashFactory,
        visualDensity: VisualDensity.compact,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Palette.secondary : Palette.elSecondary,
      ),
      visualDensity: VisualDensity.compact,
    ),
    extensions: [
      AppThemeExtension(
        elSecondary: Palette.elSecondary,
        elTertiary: Palette.elTertiary,
        myLibraryTileLikedBg: Palette.myLibraryTileLikedBg,
        myLibraryTilePlaylistsBg: Palette.myLibraryTilePlaylistsBg,
        myLibraryArtistsBg: Palette.myLibraryArtistsBg,
        success: Palette.success,
        bgPopup: Palette.bgPopup,
      ),
    ],
  );
}
