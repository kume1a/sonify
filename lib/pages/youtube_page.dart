import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/youtube/state/youtube_videos_state.dart';
import '../features/youtube/ui/youtube_home_top_bar.dart';

class YoutubePage extends StatelessWidget {
  const YoutubePage({super.key});

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
    return const Center(
      child: YoutubeHomeTopBar(),
    );
  }
}
