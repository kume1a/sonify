import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/default_back_button.dart';
import '../../../shared/ui/pulsing_fade.dart';
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
          child: _PlaylistImage(
            size: Size.infinite,
          ),
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
                        child: const _PlaylistTitle(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
  const _PlaylistImage({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.hasData
            ? CachedNetworkImage(
                width: size.width,
                height: size.height,
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
              'TODO add real count ${l.playedNTimes(10000)}',
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

class AlbumPageView extends StatefulWidget {
  const AlbumPageView({
    super.key,
    required this.text,
    required this.likesAndHours,
  });

  final String text;
  final String likesAndHours;

  @override
  _AlbumPageViewState createState() => _AlbumPageViewState();
}

class _AlbumPageViewState extends State<AlbumPageView> {
  late ScrollController _controller;
  double imageSize = 0;
  double initialSize = 240;
  double imageOpacity = 1;
  bool isAppBarHidden = false;
  @override
  void initState() {
    imageSize = initialSize;
    _controller = ScrollController()
      ..addListener(() {
        imageSize = initialSize - _controller.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }
        if (_controller.offset > 200) {
          isAppBarHidden = true;
        } else {
          isAppBarHidden = false;
        }
        imageOpacity = imageSize / initialSize;
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedImageContainer(context),
          Positioned(
            top: mediaQuery.padding.top,
            left: 0,
            child: const BackButton(),
          ),
          _buildSafeArea(context),
          _buildAnimatedAppBarContainer(context)
        ],
      ),
    );
  }

  Container _buildAnimatedImageContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.secondary,
      height: context.dynamicHeight(0.4),
      child: Padding(
        padding: context.verticalPaddingHigh,
        child: Opacity(
          opacity: imageOpacity.clamp(0, 1),
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                    offset: const Offset(0, 20),
                    blurRadius: 32,
                    spreadRadius: 16,
                  )
                ],
              ),
              child: _PlaylistImage(size: Size.square(imageSize)),
            ),
          ),
        ),
      ),
    );
  }

  SafeArea _buildSafeArea(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: _controller,
          child: _buildbAllColumn(context),
        ),
      );

  Column _buildbAllColumn(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        LinearGradientContainer(
          colors: [
            theme.scaffoldBackgroundColor.withOpacity(0),
            theme.scaffoldBackgroundColor.withOpacity(0),
            theme.scaffoldBackgroundColor.withOpacity(1),
          ],
          child: Padding(
            padding: EdgeInsets.only(top: context.lowValue),
            child: _buildMidArea(context),
          ),
        ),
        _buildAlbumCardsContainer(context)
      ],
    );
  }

  Widget _buildMidArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: initialSize + 64,
          ),
          const _PlaylistTitle(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const _PlaylistViewCount(),
          const SizedBox(height: 16),
          _buildIconsAndButtons(context)
        ],
      ),
    );
  }

  Widget _buildIconsAndButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildFavAndMoreIcon(context),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleButtonContainer(
            width: 56,
            height: 56,
            containerColor: theme.colorScheme.primaryContainer,
            iconColor: theme.colorScheme.secondary,
            icon: SvgPicture.asset(Assets.svgPlay),
            iconSize: context.dynamicWidth(0.08),
          ),
        )
      ],
    );
  }

  Row _buildFavAndMoreIcon(BuildContext context) {
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

  Container _buildAlbumCardsContainer(BuildContext context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: context.paddingNormal,
        child: _buildBottomColumn(context),
      );

  Column _buildBottomColumn(BuildContext context) => const Column();

  Positioned _buildAnimatedAppBarContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isAppBarHidden ? 1 : 0,
        child: Container(
          color: theme.colorScheme.secondary,
          child: const SafeArea(
            child: Row(
              children: [
                DefaultBackButton(),
                _PlaylistTitle(style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinearGradientContainer extends StatelessWidget {
  const LinearGradientContainer({super.key, required this.colors, required this.child});
  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}

class CircleButtonContainer extends StatelessWidget {
  const CircleButtonContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.containerColor,
      required this.iconColor,
      required this.icon,
      required this.iconSize});
  final double width;
  final double height;
  final Color containerColor;
  final Color iconColor;
  final Widget icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: containerColor, shape: BoxShape.circle),
      child: icon,
    );
  }
}
