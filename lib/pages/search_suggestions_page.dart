import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/audio/state/my_library_audios_state.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../features/search/state/spotify_search_state.dart';
import '../features/search/state/youtube_search_state.dart';
import '../features/search/ui/spotify_searched_playlists.dart';
import '../features/search/ui/spotify_searched_playlists_header.dart';
import '../features/search/ui/youtube_search_results.dart';
import '../features/search/ui/youtube_search_suggestions_header.dart';
import '../shared/ui/search_input_with_cancel.dart';

class SearchSuggestionsPageArgs {
  const SearchSuggestionsPageArgs({
    this.initialValue,
  });

  final String? initialValue;
}

class SearchSuggestionsPage extends StatelessWidget {
  const SearchSuggestionsPage({
    super.key,
    required this.args,
  });

  final SearchSuggestionsPageArgs args;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<YoutubeSearchCubit>()..init(args)),
        BlocProvider(create: (_) => getIt<SpotifySearchCubit>()..init(args)),
        BlocProvider(create: (_) => getIt<MyLibraryAudiosCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AudioPlayerPanel(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: SearchInputWithCancel(
                  onChanged: (value) {
                    context.youtubeSearchCubit.onSearchQueryChanged(value);
                    context.spotifySearchCubit.onSearchQueryChanged(value);
                  },
                  onCancelPressed: () => Navigator.of(context).maybePop(),
                  onSubmitted: context.youtubeSearchCubit.onSubmitted,
                  controller: context.youtubeSearchCubit.searchQueryController,
                ),
              ),
              const Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SpotifySearchedPlaylistsHeader(),
                    ),
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
      ),
    );
  }
}
