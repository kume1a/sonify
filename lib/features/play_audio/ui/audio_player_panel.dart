import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/ui/thumbnail.dart';
import '../../../shared/values/assets.dart';
import '../model/playback_button_state.dart';
import '../state/audio_player_state.dart';

class AudioPlayerPanel extends StatelessWidget {
  const AudioPlayerPanel({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (previous, current) => previous.currentSong != current.currentSong,
      builder: (context, state) {
        return state.currentSong.maybeWhen(
          orElse: () => body,
          success: (data) => SlidingUpPanel(
            controller: AudioPlayerCubit.panelController,
            body: body,
            panel: _PanelContent(audio: data),
            collapsed: _MiniAudioPlayer(audio: data),
            minHeight: 56,
            color: theme.scaffoldBackgroundColor,
            maxHeight: mediaQuery.size.height,
          ),
        );
      },
    );
  }
}

class _PanelContent extends StatelessWidget {
  const _PanelContent({
    required this.audio,
  });

  final Audio audio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AudioPlayerHeader(),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (_, constraints) {
          return _AudioPlayerImage(
            size: Size.square(constraints.maxWidth * 0.75),
            audio: audio,
          );
        }),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _AudioPlayerControls(),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

class _MiniAudioPlayer extends StatelessWidget {
  const _MiniAudioPlayer({
    required this.audio,
  });

  final Audio audio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _AudioPlayerImage(
              size: const Size.square(42),
              audio: audio,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                buildWhen: (previous, current) => previous.currentSong != current.currentSong,
                builder: (_, state) {
                  return state.currentSong.maybeWhen(
                    orElse: () => const SizedBox.shrink(),
                    success: (data) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title.trim(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data.author.trim(),
                          style: const TextStyle(fontSize: 11),
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
            const _PlayPauseButton(dimension: 20),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                Assets.svgSkipForward,
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioPlayerImage extends HookWidget {
  const _AudioPlayerImage({
    required this.size,
    required this.audio,
  });

  final Size size;
  final Audio audio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Thumbnail(
          size: size,
          thumbnailPath: audio.thumbnailPath,
          thumbnailUrl: audio.thumbnailUrl,
          borderRadius: BorderRadius.circular(size.longestSide * 0.1),
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
            onPressed: context.audioPlayerCubit.onDownArrowPressed,
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
        const _PlayPauseButton(dimension: 32),
        SvgPicture.asset(Assets.svgSkipForward),
        SvgPicture.asset(Assets.svgHeart),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.dimension,
  });

  final double dimension;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.audioPlayerCubit.onPlayOrPause,
      visualDensity: VisualDensity.compact,
      icon: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        buildWhen: (previous, current) => previous.playButtonState != current.playButtonState,
        builder: (_, state) {
          return switch (state.playButtonState) {
            PlaybackButtonState.idle || PlaybackButtonState.loading => SizedBox.square(
                dimension: dimension,
                child: const CircularProgressIndicator(),
              ),
            PlaybackButtonState.paused => SvgPicture.asset(
                Assets.svgPlay,
                width: dimension,
                height: dimension,
              ),
            PlaybackButtonState.playing => SvgPicture.asset(
                Assets.svgPause,
                width: dimension,
                height: dimension,
              ),
          };
        },
      ),
    );
  }
}
