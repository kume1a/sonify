import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/assets.dart';
import '../state/spotify_search_state.dart';
import '../state/youtube_search_state.dart';

class SearchSuggestionsInput extends StatelessWidget {
  const SearchSuggestionsInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            autocorrect: false,
            onChanged: (value) {
              context.youtubeSearchCubit.onSearchQueryChanged(value);
              context.spotifySearchCubit.onSearchQueryChanged(value);
            },
            decoration: InputDecoration(
              hintText: l.search,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 6),
                child: SvgPicture.asset(Assets.svgSearch),
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(width: 32, height: 24),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        const SizedBox(width: 20),
        MaterialButton(
          onPressed: () => Navigator.of(context).maybePop(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 32,
          minWidth: 10,
          child: Text(
            l.cancel,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
