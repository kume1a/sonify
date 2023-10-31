import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/logo_header.dart';
import '../../../shared/values/assets.dart';

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
          SvgPicture.asset(
            Assets.svgSearch,
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
