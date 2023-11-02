import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonify_video_player/sonify_video_player.dart';
import 'package:video_player/video_player.dart';

import '../state/youtube_video_state.dart';

class YoutubeVideo extends StatefulWidget {
  const YoutubeVideo({super.key});

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  VideoPlayerController? _videoPlayerController;
  SonifyVideoPlayerController? _sonifyVideoPlayerController;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _sonifyVideoPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitializing = _sonifyVideoPlayerController != null &&
        _sonifyVideoPlayerController!.videoPlayerController.value.isInitialized;

    return BlocListener<YoutubeVideoCubit, YoutubeVideoState>(
      listenWhen: (previous, current) => previous.videoUri != current.videoUri,
      listener: (_, state) => _reinitializePlayer(state),
      child: isInitializing
          ? SonifyVideoPlayer(controller: _sonifyVideoPlayerController!)
          : const _VideoBlankLoader(),
    );
  }

  Future<void> _reinitializePlayer(YoutubeVideoState state) async {
    if (state.videoUri == null) {
      return;
    }

    await _videoPlayerController?.dispose();
    _sonifyVideoPlayerController?.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(state.videoUri!);
    await _videoPlayerController!.initialize();

    _sonifyVideoPlayerController = SonifyVideoPlayerController(
      videoPlayerController: _videoPlayerController!,
      // autoPlay: true,
      looping: true,
      hideControlsTimer: const Duration(seconds: 2, milliseconds: 500),
    );

    setState(() {});
  }
}

class _VideoBlankLoader extends StatelessWidget {
  const _VideoBlankLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
