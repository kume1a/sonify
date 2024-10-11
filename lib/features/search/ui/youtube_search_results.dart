import 'package:common_widgets/common_widgets.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/values/assets.dart';
import '../../search/state/youtube_search_state.dart';
import '../state/spotify_search_state.dart';

class YoutubeSearchResults extends StatelessWidget {
  const YoutubeSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeSearchCubit, YoutubeSearchState>(
      builder: (_, state) {
        return state.maybeWhen(
          success: (data) => _SuggestionList(data),
          loading: () => const _BlankAnimatedList(),
          orElse: () => const SliverToBoxAdapter(),
        );
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList(this.data);

  final YoutubeSearchSuggestions data;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: data.suggestions.length,
      itemBuilder: (_, index) {
        final suggestion = data.suggestions[index];

        return InkWell(
          onTap: () => context.youtubeSearchCubit.onSearchSuggestionPressed(suggestion),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 6, 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svgSearch,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.youtubeSearchCubit.onSearchSuggestionFillPressed(suggestion);
                    context.youtubeSearchCubit.onSearchQueryChanged(suggestion);
                    context.spotifySearchCubit.onSearchQueryChanged(suggestion);
                  },
                  icon: const Icon(Icons.arrow_outward),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BlankAnimatedList extends StatelessWidget {
  const _BlankAnimatedList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PulsingFade.sliver(
      child: SliverList.builder(
        itemCount: 20,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                color: theme.colorScheme.secondaryContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlankContainer(
                  height: 16,
                  color: theme.colorScheme.secondaryContainer,
                ),
              ),
              BlankContainer.circular(
                margin: const EdgeInsets.only(left: 16),
                radius: 14,
                color: theme.colorScheme.secondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
