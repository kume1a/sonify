import 'package:flutter/material.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/default_back_button.dart';

class YoutubeSearchBar extends StatelessWidget {
  const YoutubeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        const DefaultBackButton(),
        const SizedBox(width: 6),
        TextField(
          decoration: InputDecoration(
            hintText: l.search,
          ),
        ),
      ],
    );
  }
}
