import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/logo_header.dart';
import '../../../shared/values/assets.dart';
import '../state/youtube_home_videos_state.dart';

class YoutubeHomeTopBar extends StatelessWidget {
  const YoutubeHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoHeader(),
          IconButton(
            onPressed: context.youtubeHomeVideosCubit.onSearchPressed,
            splashRadius: 24,
            icon: SvgPicture.asset(
              Assets.svgSearch,
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
