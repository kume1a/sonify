import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/round_play_button.dart';
import '../../../shared/values/assets.dart';

class MyLibraryHeader extends StatelessWidget {
  const MyLibraryHeader({super.key});

  static final double height = 26.h;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        RoundPlayButton(
          size: height,
          iconSize: 16.h,
          isPlaying: false,
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            l.shufflePlayback,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SvgPicture.asset(
          Assets.svgArrowDownUp,
          width: 16.h,
          height: 16.h,
        ),
      ],
    );
  }
}
