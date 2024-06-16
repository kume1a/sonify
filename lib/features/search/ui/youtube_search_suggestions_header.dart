import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/assets.dart';

class YoutubeSearchSuggestionsHeader extends StatelessWidget {
  const YoutubeSearchSuggestionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        SvgPicture.asset(Assets.svgYoutube, width: 24, height: 24),
        const SizedBox(width: 6),
        const Text('TODO'),
      ],
    );
  }
}
