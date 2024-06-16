import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/search/state/spotify_search_state.dart';
import '../features/search/state/youtube_search_state.dart';
import '../features/search/ui/search_suggestions_input.dart';
import '../features/search/ui/spotify_searched_playlists.dart';
import '../features/search/ui/youtube_search_results.dart';
import '../features/search/ui/youtube_search_suggestions_header.dart';

class SearchSuggestionsPage extends StatelessWidget {
  const SearchSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<YoutubeSearchCubit>()),
        BlocProvider(create: (_) => getIt<SpotifySearchCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SearchSuggestionsInput(),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SpotifySearchedPlaylists(),
                  ),
                  SliverToBoxAdapter(
                    child: YoutubeSearchSuggestionsHeader(),
                  ),
                  YoutubeSearchResults(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
