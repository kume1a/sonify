import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/youtube/state/youtube_video_state.dart';
import '../features/youtube/ui/download_youtube_video_button.dart';
import '../features/youtube/ui/youtube_video.dart';
import '../features/youtube/ui/youtube_video_info.dart';
import '../shared/ui/default_back_button.dart';

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
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);

    return const Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubeVideo(),
                ),
                Positioned(
                  left: 4,
                  top: 4,
                  child: DefaultBackButton(),
                ),
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: padding,
              child: YoutubeVideoInfo(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: padding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: DownloadYoutubeVideoButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
