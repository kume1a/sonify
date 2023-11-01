import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';
import '../model/youtube_search_suggestions.dart';
import '../state/youtube_search_state.dart';

class YoutubeSearchResults extends StatelessWidget {
  const YoutubeSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeSearchCubit, YoutubeSearchState>(
      builder: (_, state) {
        return state.maybeWhen(
          success: (data) => _SuggestionList(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
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
    return ListView.builder(
      itemCount: data.suggestions.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (_, index) {
        final suggestion = data.suggestions[index];

        return InkWell(
          onTap: () => context.youtubeSearchCubit.onSearchSuggestionPressed(suggestion),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svgSearch,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  suggestion,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
