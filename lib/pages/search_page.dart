import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/youtube/state/youtube_videos_state.dart';
import '../features/youtube/ui/youtube_home_top_bar.dart';
import '../features/youtube/ui/youtube_home_videos.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<YoutubeVideosCubit>(),
        )
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        YoutubeHomeTopBar(),
        YoutubeHomeVideos(),
      ],
    );
  }
}
