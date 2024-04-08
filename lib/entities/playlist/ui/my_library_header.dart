import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/round_play_button.dart';
import '../../../shared/values/assets.dart';

class MyLibraryHeader extends StatelessWidget {
  const MyLibraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        const RoundPlayButton(dimension: 26),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l.shufflePlayback,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        SvgPicture.asset(
          Assets.svgArrowDownUp,
          width: 18,
          height: 18,
        ),
      ],
    );
  }
}
