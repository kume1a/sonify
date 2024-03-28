import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/audio_thumbnail.dart';
import '../../../shared/values/assets.dart';
import '../model/playback_button_state.dart';
import '../state/audio_player_state.dart';

class AudioPlayerPanel extends StatelessWidget {
  const AudioPlayerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AudioPlayerHeader(),
        SizedBox(height: 24),
        _AudioPlayerImage(),
        SizedBox(height: 32),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _AudioPlayerControls(),
        ),
        Spacer(flex: 3),
      ],
    );
  }
}

class _AudioPlayerImage extends HookWidget {
  const _AudioPlayerImage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          buildWhen: (previous, current) => previous.currentSong != current.currentSong,
          builder: (_, state) {
            return state.currentSong.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              success: (data) => AudioThumbnail(
                dimension: constraints.maxWidth * 0.75,
                thumbnailPath: data.thumbnailPath ?? '',
                borderRadius: BorderRadius.circular(18),
              ),
            );
          },
        );
      },
    );
  }
}

class _AudioPlayerHeader extends StatelessWidget {
  const _AudioPlayerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            iconSize: 28,
            icon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right),
            ),
          ),
          Expanded(
            child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
              builder: (context, state) {
                if (state.playlistName == null) {
                  return const SizedBox.shrink();
                }

                return const Column(
                  children: [
                    Text(
                      'Playlist name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Playlist',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.svgQuillList),
          ),
        ],
      ),
    );
  }
}

class _AudioPlayerControls extends StatelessWidget {
  const _AudioPlayerControls();

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
