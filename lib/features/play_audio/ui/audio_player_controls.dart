import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';

import '../../../shared/values/assets.dart';

class AudioPlayerControls extends StatelessWidget {
  const AudioPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MetaAndPlayMode(),
        SizedBox(height: 20),
        _Progress(),
        SizedBox(height: 36),
        _Controls(),
      ],
    );
  }
}

class _MetaAndPlayMode extends StatelessWidget {
  const _MetaAndPlayMode();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Music name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'Artist name',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(Assets.svgShuffle),
        ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress();

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: const Duration(milliseconds: 1000),
      buffered: const Duration(milliseconds: 2000),
      total: const Duration(milliseconds: 5000),
      onSeek: (duration) {
        Logger.root.info('User selected a new time: $duration');
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(Assets.svgRepeat),
        SvgPicture.asset(Assets.svgSkipBack),
        SvgPicture.asset(Assets.svgPlay),
        SvgPicture.asset(Assets.svgSkipForward),
        SvgPicture.asset(Assets.svgHeart),
      ],
    );
  }
}
