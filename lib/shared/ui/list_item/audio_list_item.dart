import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/color.dart';
import '../../util/random.dart';
import '../../values/app_theme_extension.dart';
import '../../values/assets.dart';
import '../thumbnail.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({
    super.key,
    required this.onTap,
    required this.audio,
    required this.isPlaying,
    this.isDisabled = false,
    this.showDownloadedIndicator = false,
    this.padding,
    this.onMenuPressed,
  });

  static final height = 46.h;

  final VoidCallback onTap;
  final Audio audio;
  final bool isPlaying;
  final bool isDisabled;
  final EdgeInsets? padding;
  final bool showDownloadedIndicator;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasThumbnail =
        audio.thumbnailPath != null || audio.thumbnailUrl != null || audio.localThumbnailPath != null;

    final thumbnail = Thumbnail(
      thumbnailPath: audio.thumbnailPath,
      thumbnailUrl: audio.thumbnailUrl,
      localThumbnailPath: audio.localThumbnailPath,
      borderRadius: BorderRadius.circular(8.r),
      size: Size.square(36.r),
    );

    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: height,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.r),
        child: Row(
          children: [
            if (hasThumbnail)
              Container(
                padding: EdgeInsets.only(right: 10.w),
                foregroundDecoration: BoxDecoration(color: isDisabled ? Colors.black38 : null),
                child: thumbnail,
              ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          audio.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isPlaying
                                ? theme.colorScheme.secondary
                                : isDisabled
                                    ? theme.appThemeExtension?.elSecondary
                                    : null,
                          ),
                        ),
                        Row(
                          children: [
                            if (showDownloadedIndicator && audio.localPath != null)
                              Padding(
                                padding: EdgeInsets.only(right: 4.w),
                                child: SvgPicture.asset(
                                  Assets.svgDownload,
                                  width: 12,
                                  height: 12,
                                  colorFilter: svgColor(theme.appThemeExtension?.success),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                audio.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDisabled
                                      ? theme.appThemeExtension?.elTertiary
                                      : theme.appThemeExtension?.elSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isPlaying)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: SvgPicture.asset(
                        Assets.svgAudioLines,
                        width: 16,
                        height: 16,
                        colorFilter: svgColor(theme.colorScheme.secondary),
                      ),
                    ),
                  if (onMenuPressed != null)
                    IconButton(
                      icon: SvgPicture.asset(
                        Assets.svgMenuVertical,
                        colorFilter: svgColor(
                          isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onSurface,
                        ),
                      ),
                      splashRadius: 24,
                      onPressed: isDisabled ? null : onMenuPressed,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlankAudioListItem extends StatelessWidget {
  const BlankAudioListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: AudioListItem.height,
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: randomDouble(100, 400),
                    height: 12.h,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: randomDouble(30, 80),
                    height: 10.h,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
