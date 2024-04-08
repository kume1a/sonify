import 'package:flutter/material.dart';

extension ThemeDataX on ThemeData {
  AppThemeExtension? get appThemeExtension => extension<AppThemeExtension>();
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.elSecondary,
    required this.myLibraryTileLikedBg,
    required this.myLibraryTilePlaylistsBg,
    required this.myLibraryArtistsBg,
  });

  final Color elSecondary;
  final Color myLibraryTileLikedBg;
  final Color myLibraryTilePlaylistsBg;
  final Color myLibraryArtistsBg;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? elSecondary,
    Color? myLibraryTileLikedBg,
    Color? myLibraryTilePlaylistsBg,
    Color? myLibraryArtistsBg,
  }) {
    return AppThemeExtension(
      elSecondary: elSecondary ?? this.elSecondary,
      myLibraryTileLikedBg: myLibraryTileLikedBg ?? this.myLibraryTileLikedBg,
      myLibraryTilePlaylistsBg: myLibraryTilePlaylistsBg ?? this.myLibraryTilePlaylistsBg,
      myLibraryArtistsBg: myLibraryArtistsBg ?? this.myLibraryArtistsBg,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      elSecondary: Color.lerp(elSecondary, other.elSecondary, t) ?? elSecondary,
      myLibraryTileLikedBg:
          Color.lerp(myLibraryTileLikedBg, other.myLibraryTileLikedBg, t) ?? myLibraryTileLikedBg,
      myLibraryTilePlaylistsBg:
          Color.lerp(myLibraryTilePlaylistsBg, other.myLibraryTilePlaylistsBg, t) ?? myLibraryTilePlaylistsBg,
      myLibraryArtistsBg: Color.lerp(myLibraryArtistsBg, other.myLibraryArtistsBg, t) ?? myLibraryArtistsBg,
    );
  }
}
