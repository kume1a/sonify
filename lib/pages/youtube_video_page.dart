import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

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
    Logger.root.info(args.videoId);
    return BlocProvider(
      create: (_) => getIt<YoutubeVideoCubit>()..init(args.videoId),
      lazy: false,
      child: _Content(args: args),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.args,
  });

  final YoutubeVideoPageArgs args;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Stack(
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
            const SizedBox(height: 12),
            const Padding(
              padding: padding,
              child: YoutubeVideoInfo(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: padding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: DownloadYoutubeVideoButton(videoId: args.videoId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
