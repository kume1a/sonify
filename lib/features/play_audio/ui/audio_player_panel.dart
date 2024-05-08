import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/optional_marquee.dart';
import '../../../shared/ui/play_pause.dart';
import '../../../shared/ui/sliding_up_panel.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../model/playback_button_state.dart';
import '../state/audio_player_controls_state.dart';
import '../state/audio_player_panel_state.dart';
import '../state/now_playing_audio_state.dart';

class AudioPlayerPanel extends StatelessWidget {
  const AudioPlayerPanel({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
        buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
        builder: (_, state) => _Panel(
          body: body,
          audio: state.nowPlayingAudio.getOrNull,
        ),
      ),
    );
  }
}

class _Panel extends HookWidget {
  const _Panel({
    required this.body,
    required this.audio,
  });

  final Widget body;
  final Audio? audio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final panelPosition = useState(0.0);

    return SlidingUpPanel(
      body: body,
      controller: context.audioPlayerPanelCubit.panelController,
      minHeight: audio != null ? 56.h : 0,
      maxHeight: mediaQuery.size.height + 100,
      panel: audio != null ? _PanelContent(audio: audio!) : const SizedBox.shrink(),
      collapsed: audio != null && panelPosition.value < 1 ? _MiniAudioPlayer(audio: audio!) : null,
      onPanelSlide: (position) => panelPosition.value = position,
      color: theme.scaffoldBackgroundColor,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _AudioPlayerControls(audio: audio),
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

    return GestureDetector(
      onTap: context.audioPlayerPanelCubit.onMiniAudioPlayerPanelPressed,
      child: Container(
        color: theme.colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _AudioPlayerImage(
              size: const Size.square(42),
              audio: audio,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
                buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
                builder: (_, state) {
                  return state.nowPlayingAudio.maybeWhen(
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
            const _PlayPauseButton(size: 24),
            const _SkipToNextButton(size: 20),
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
          localThumbnailPath: audio.localThumbnailPath,
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
            onPressed: context.audioPlayerPanelCubit.onDownArrowPressed,
            iconSize: 28,
            icon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right),
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
  const _AudioPlayerControls({
    required this.audio,
  });

  final Audio audio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _MetaAndPlayMode(),
        const SizedBox(height: 20),
        const _Progress(),
        const SizedBox(height: 24),
        _Controls(audio: audio),
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
          child: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
            buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
            builder: (_, state) {
              return state.nowPlayingAudio.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                success: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OptionalMarquee(
                      height: 24,
                      text: data.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
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
    return BlocBuilder<AudioPlayerControlsCubit, AudioPlayerControlsState>(
      buildWhen: (previous, current) => previous.playbackProgress != current.playbackProgress,
      builder: (_, state) {
        if (state.playbackProgress == null) {
          return const SizedBox.shrink();
        }

        return ProgressBar(
          progress: state.playbackProgress!.current,
          buffered: state.playbackProgress!.buffered,
          total: state.playbackProgress!.total,
          onSeek: context.audioPlayerControlsCubit.onSeek,
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.audio,
  });

  final Audio audio;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          Assets.svgRepeat,
          width: 24,
          height: 24,
        ),
        const _SkipToPreviousButton(size: 28),
        const _PlayPauseButton(size: 38),
        const _SkipToNextButton(size: 28),
        IconButton(
          onPressed: context.nowPlayingAudioCubit.onLikePressed,
          icon: SvgPicture.asset(
            audio.isLiked ? Assets.svgHeartFilled : Assets.svgHeart,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.audioPlayerControlsCubit.onPlayOrPause,
      iconSize: size,
      icon: BlocBuilder<AudioPlayerControlsCubit, AudioPlayerControlsState>(
        buildWhen: (previous, current) => previous.playButtonState != current.playButtonState,
        builder: (_, state) {
          final isLoading = state.playButtonState == PlaybackButtonState.idle ||
              state.playButtonState == PlaybackButtonState.loading;

          if (isLoading) {
            return SizedBox.square(
              dimension: size,
              child: const CircularProgressIndicator(),
            );
          }

          return PlayPause(
            isPlaying: state.playButtonState == PlaybackButtonState.playing,
            size: size,
          );
        },
      ),
    );
  }
}

class _SkipToPreviousButton extends StatelessWidget {
  const _SkipToPreviousButton({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AudioPlayerControlsCubit, AudioPlayerControlsState>(
      buildWhen: (previous, current) => previous.isFirstSong != current.isFirstSong,
      builder: (_, state) {
        final isDisabled = state.isFirstSong;

        return IconButton(
          onPressed: isDisabled ? null : context.audioPlayerControlsCubit.onSkipToPrevious,
          visualDensity: VisualDensity.compact,
          icon: SvgPicture.asset(
            width: size,
            height: size,
            Assets.svgSkipBack,
            colorFilter: svgColor(
              isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onBackground,
            ),
          ),
        );
      },
    );
  }
}

class _SkipToNextButton extends StatelessWidget {
  const _SkipToNextButton({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AudioPlayerControlsCubit, AudioPlayerControlsState>(
      buildWhen: (previous, current) => previous.isLastSong != current.isLastSong,
      builder: (_, state) {
        final isDisabled = state.isLastSong;

        return IconButton(
          onPressed: isDisabled ? null : context.audioPlayerControlsCubit.onSkipToNext,
          visualDensity: VisualDensity.compact,
          icon: SvgPicture.asset(
            Assets.svgSkipForward,
            width: size,
            height: size,
            colorFilter: svgColor(
              isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onBackground,
            ),
          ),
        );
      },
    );
  }
}
