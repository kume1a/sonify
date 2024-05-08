import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';

class MyLibraryTiles extends StatelessWidget {
  const MyLibraryTiles({super.key});

  static final double tileHeight = 62.h;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _MyLibraryTile(
            backgroundColor: theme.appThemeExtension?.myLibraryTileLikedBg,
            iconAssetPath: Assets.svgHeartFilled,
            label: l.liked,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _MyLibraryTile(
            backgroundColor: theme.appThemeExtension?.myLibraryTilePlaylistsBg,
            iconAssetPath: Assets.svgPlaylist,
            label: l.playlists,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _MyLibraryTile(
            backgroundColor: theme.appThemeExtension?.myLibraryArtistsBg,
            iconAssetPath: Assets.svgMic,
            label: l.artists,
          ),
        ),
      ],
    );
  }
}

class _MyLibraryTile extends StatelessWidget {
  const _MyLibraryTile({
    required this.backgroundColor,
    required this.iconAssetPath,
    required this.label,
  });

  final Color? backgroundColor;
  final String iconAssetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyLibraryTiles.tileHeight,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconAssetPath,
            width: 20.w,
            height: 20.w,
            colorFilter: svgColor(Colors.white),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
