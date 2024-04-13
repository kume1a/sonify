import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/pulsing_fade.dart';
import '../../../shared/ui/round_play_button.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/playlist_state.dart';

class PlaylistAppBar implements SliverPersistentHeaderDelegate {
  const PlaylistAppBar({
    required this.minExtent,
    required this.maxExtent,
  });

  @override
  final double minExtent;

  @override
  final double maxExtent;

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
                const _PlaylistViewCount(),
                const SizedBox(height: 12),
                const _OptionButtons(),
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
          top: mediaQueryData.padding.top + 4,
          child: Row(
            children: [
              BackButton(color: iconColor),
              Opacity(
                opacity: colorProgress,
                child: const _PlaylistTitle(
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: -20,
          child: BlocBuilder<PlaylistCubit, PlaylistState>(
            buildWhen: (previous, current) => previous.isPlaylistPlaying != current.isPlaylistPlaying,
            builder: (_, state) {
              return RoundPlayButton(
                size: 52,
                isPlaying: state.isPlaylistPlaying,
                onPressed: context.playlistCubit.onPlayPlaylistPressed,
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
      buildWhen: (previous, current) => previous.playlist != current.playlist,
      builder: (_, state) {
        return state.playlist.hasData
            ? CachedNetworkImage(
                imageUrl: state.playlist.getOrThrow.thumbnailUrl ?? '',
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
      buildWhen: (previous, current) => previous.playlist != current.playlist,
      builder: (_, state) {
        return state.playlist.maybeWhen(
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

class _PlaylistViewCount extends StatelessWidget {
  const _PlaylistViewCount();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return Row(
          children: [
            SvgPicture.asset(
              Assets.svgMusicNote,
              width: 16,
              height: 16,
              colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
            ),
            const SizedBox(width: 5),
            Text(
              'TODO ${l.playedNTimes(10000)}',
              style: TextStyle(
                fontSize: 12,
                color: theme.appThemeExtension?.elSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OptionButtons extends StatelessWidget {
  const _OptionButtons();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SvgPicture.asset(
          Assets.svgHeart,
          width: 20,
          height: 20,
          colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
        ),
        const SizedBox(width: 12),
        SvgPicture.asset(
          Assets.svgDownload,
          width: 20,
          height: 20,
          colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
        ),
        const SizedBox(width: 12),
        SvgPicture.asset(
          Assets.svgMenuVertical,
          width: 20,
          height: 20,
          colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
        ),
      ],
    );
  }
}
