import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/assets.dart';
import '../state/youtube_search_state.dart';

class YoutubeSearchSuggestionsHeader extends StatelessWidget {
  const YoutubeSearchSuggestionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeSearchCubit, YoutubeSearchState>(
      builder: (_, state) => state.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        success: (data) => data.suggestions.isEmpty ? const SizedBox.shrink() : const _Header(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          SvgPicture.asset(Assets.svgYoutube, width: 14, height: 14),
          const SizedBox(width: 6),
          Text(
            l.youtubeSuggestions,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
