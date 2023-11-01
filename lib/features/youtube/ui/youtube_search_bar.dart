import 'package:flutter/material.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/default_back_button.dart';
import '../state/youtube_search_state.dart';

class YoutubeSearchBar extends StatelessWidget {
  const YoutubeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        const DefaultBackButton(),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            autofocus: true,
            autocorrect: false,
            onChanged: context.youtubeSearchCubit.onSearchQueryChanged,
            decoration: InputDecoration(
              hintText: l.search,
            ),
          ),
        ),
      ],
    );
  }
}
