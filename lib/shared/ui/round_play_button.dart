import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../values/assets.dart';

class RoundPlayButton extends StatelessWidget {
  const RoundPlayButton({super.key, required this.dimension});

  final double dimension;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(color: theme.colorScheme.secondary, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        Assets.svgPlay,
        width: dimension / 2,
        height: dimension / 2,
      ),
    );
  }
}
