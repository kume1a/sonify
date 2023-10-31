import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../values/assets.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.svgLogoTransparentBg,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        const Text(
          'Sonify',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
