import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../features/play_audio/model/playback_button_state.dart';
import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/ui/round_play_button.dart';
import '../../../shared/values/assets.dart';
import '../state/playlist_state.dart';

class PlaylistAppBar implements SliverPersistentHeaderDelegate {
  const PlaylistAppBar({
    required this.minExtent,
    required this.maxExtent,
    required this.playlistId,
  });

  @override
  final double minExtent;

  @override
  final double maxExtent;

  final String playlistId;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final mediaQueryData = MediaQuery.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    final offset = shrinkOffset / maxExtent;

    final colorProgress = const Interval(.2, .8).transform(offset);
    final iconColor = theme.brightness == Brightness.light
        ? ColorTween(begin: Colors.white, end: Colors.black).lerp(colorProgress)
        : Colors.white;

    final contentOpacity = 1 - const Interval(.1, .5).transform(offset);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: _PlaylistImage(),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  theme.scaffoldBackgroundColor,
                ],
                stops: const [.4, 1],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.black12,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: -20,
          child: Opacity(
            opacity: contentOpacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.playlist,
                  style: const TextStyle(fontSize: 12),
                ),
                const _PlaylistTitle(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: colorProgress,
            child: ColoredBox(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
        Positioned(
          left: 2,
          right: 32,
          top: mediaQueryData.padding.top + 4,
          child: Row(
            children: [
              BackButton(color: iconColor),
              Expanded(
                child: Opacity(
                  opacity: colorProgress,
                  child: const _PlaylistTitle(
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Opacity(
            opacity: 1 - colorProgress,
            child: IconButton(
              onPressed: colorProgress < .2 ? context.playlistCubit.onDownloadPlaylistPressed : null,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              icon: SvgPicture.asset(
                Assets.svgDownload,
              ),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: -20,
          child: BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
            buildWhen: (previous, current) =>
                previous.playlist != current.playlist || previous.playButtonState != current.playButtonState,
            builder: (_, state) {
              return RoundPlayButton(
                size: 52,
                iconSize: 26,
                isPlaying:
                    state.playlist?.id == playlistId && state.playButtonState == PlaybackButtonState.playing,
                onPressed: () => context.nowPlayingAudioCubit.onPlayPlaylistPressed(playlistId: playlistId),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate delegate) => true;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration => null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}

class _PlaylistImage extends StatelessWidget {
  const _PlaylistImage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.hasData
            ? CachedNetworkImage(
                imageUrl: state.getOrThrow.thumbnailUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => ColoredBox(color: theme.colorScheme.secondaryContainer),
                errorWidget: (_, __, ___) => ColoredBox(color: theme.colorScheme.secondaryContainer),
              )
            : ColoredBox(color: theme.colorScheme.secondaryContainer);
      },
    );
  }
}

class _PlaylistTitle extends StatelessWidget {
  const _PlaylistTitle({
    required this.style,
  });

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          success: (data) => Text(
            data.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(color: Colors.white),
          ),
          loading: () => PulsingFade(
            child: BlankContainer(
              width: 140,
              height: 17,
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
