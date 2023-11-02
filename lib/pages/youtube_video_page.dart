import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../app/di/register_dependencies.dart';
import '../features/youtube/state/youtube_video_state.dart';

class YoutubeVideoPageArgs {
  YoutubeVideoPageArgs({
    required this.videoId,
  });

  final String videoId;
}

class YoutubeVideoPage extends StatelessWidget {
  const YoutubeVideoPage({
    super.key,
    required this.args,
  });

  final YoutubeVideoPageArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<YoutubeVideoCubit>()..init(args.videoId),
      lazy: false,
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
