import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/youtube/state/youtube_search_state.dart';
import '../features/youtube/ui/youtube_search_bar.dart';
import '../features/youtube/ui/youtube_search_results.dart';

class YoutubeSearchPage extends StatelessWidget {
  const YoutubeSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<YoutubeSearchCubit>()),
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
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: 2, right: 16),
              child: YoutubeSearchBar(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: YoutubeSearchResults(),
            )
          ],
        ),
      ),
    );
  }
}
