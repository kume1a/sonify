import 'package:flutter/material.dart';

extension ThemeDataX on ThemeData {
  AppThemeExtension? get appThemeExtension => extension<AppThemeExtension>();
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.elSecondary,
    required this.elTertiary,
    required this.myLibraryTileLikedBg,
    required this.myLibraryTilePlaylistsBg,
    required this.myLibraryArtistsBg,
    required this.success,
    required this.bgPopup,
  });

  final Color elSecondary;
  final Color elTertiary;
  final Color myLibraryTileLikedBg;
  final Color myLibraryTilePlaylistsBg;
  final Color myLibraryArtistsBg;
  final Color success;
  final Color bgPopup;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? elSecondary,
    Color? elTertiary,
    Color? myLibraryTileLikedBg,
    Color? myLibraryTilePlaylistsBg,
    Color? myLibraryArtistsBg,
    Color? success,
    Color? bgPopup,
  }) {
    return AppThemeExtension(
      elSecondary: elSecondary ?? this.elSecondary,
      elTertiary: elTertiary ?? this.elTertiary,
      myLibraryTileLikedBg: myLibraryTileLikedBg ?? this.myLibraryTileLikedBg,
      myLibraryTilePlaylistsBg: myLibraryTilePlaylistsBg ?? this.myLibraryTilePlaylistsBg,
      myLibraryArtistsBg: myLibraryArtistsBg ?? this.myLibraryArtistsBg,
      success: success ?? this.success,
      bgPopup: bgPopup ?? this.bgPopup,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      elSecondary: Color.lerp(elSecondary, other.elSecondary, t) ?? elSecondary,
      elTertiary: Color.lerp(elTertiary, other.elTertiary, t) ?? elTertiary,
      myLibraryTileLikedBg:
          Color.lerp(myLibraryTileLikedBg, other.myLibraryTileLikedBg, t) ?? myLibraryTileLikedBg,
      myLibraryTilePlaylistsBg:
          Color.lerp(myLibraryTilePlaylistsBg, other.myLibraryTilePlaylistsBg, t) ?? myLibraryTilePlaylistsBg,
      myLibraryArtistsBg: Color.lerp(myLibraryArtistsBg, other.myLibraryArtistsBg, t) ?? myLibraryArtistsBg,
      success: Color.lerp(success, other.success, t) ?? success,
      bgPopup: Color.lerp(bgPopup, other.bgPopup, t) ?? bgPopup,
    );
  }
}
