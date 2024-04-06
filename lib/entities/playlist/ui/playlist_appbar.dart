import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/pulsing_fade.dart';
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
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    final double offset = shrinkOffset / maxExtent;

    // calculated with linear formula
    // .6k + b = 1
    // .5k + b = 0
    final double colorProgress = (offset < .5 ? 0 : offset * 10 - 5).clamp(0, 1).toDouble();
    final Color? iconColor = theme.brightness == Brightness.light
        ? ColorTween(begin: Colors.white, end: Colors.black).lerp(colorProgress)
        : Colors.white;

    final double contentOpacity = offset < .1 ? 1 : (offset * -10) + 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: _PlaylistImage(),
        ),
        const Positioned.fill(
          child: ColoredBox(color: Colors.black26),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (offset < .2)
                      Opacity(
                        opacity: contentOpacity,
                        child: const _PlaylistTitle(),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: colorProgress,
            child: ColoredBox(
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: mediaQueryData.padding.top + 4,
          child: BackButton(color: iconColor),
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
  const _PlaylistTitle();

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
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
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
              width: 14,
              height: 14,
              color: theme.appThemeExtension?.elSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              'TODO add real count ${l.playedNTimes(10000)}',
              style: TextStyle(
                fontSize: 11,
                color: theme.appThemeExtension?.elSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
