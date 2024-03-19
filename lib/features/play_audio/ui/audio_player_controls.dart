import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';
import '../model/playback_button_state.dart';
import '../state/audio_player_state.dart';

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
        Expanded(
          child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
            buildWhen: (previous, current) => previous.currentSong != current.currentSong,
            builder: (_, state) {
              return state.currentSong.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                success: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data.author,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
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
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (previous, current) => previous.playbackProgress != current.playbackProgress,
      builder: (_, state) {
        if (state.playbackProgress == null) {
          return const SizedBox.shrink();
        }

        return ProgressBar(
          progress: state.playbackProgress!.current,
          buffered: state.playbackProgress!.buffered,
          total: state.playbackProgress!.total,
          onSeek: context.audioPlayerCubit.onSeek,
        );
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
        IconButton(
          onPressed: context.audioPlayerCubit.onPlayOrPause,
          icon: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
            buildWhen: (previous, current) => previous.playButtonState != current.playButtonState,
            builder: (_, state) {
              return switch (state.playButtonState) {
                PlaybackButtonState.idle || PlaybackButtonState.loading => const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(),
                  ),
                PlaybackButtonState.paused => SvgPicture.asset(Assets.svgPlay),
                PlaybackButtonState.playing => SvgPicture.asset(Assets.svgPause),
              };
            },
          ),
        ),
        SvgPicture.asset(Assets.svgSkipForward),
        SvgPicture.asset(Assets.svgHeart),
      ],
    );
  }
}
