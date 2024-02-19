import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../values/assets.dart';

class LogoHeaderSmall extends StatelessWidget {
  const LogoHeaderSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LogoHeader(
      iconSize: 24,
      fontSize: 14,
    );
  }
}

class LogoHeaderMedium extends StatelessWidget {
  const LogoHeaderMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LogoHeader(
      iconSize: 36,
      fontSize: 24,
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader({
    required this.iconSize,
    required this.fontSize,
  });

  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.svgLogoTransparentBg,
          width: iconSize,
          height: iconSize,
        ),
        const SizedBox(width: 8),
        Text(
          'Sonify',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
