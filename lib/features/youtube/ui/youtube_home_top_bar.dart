import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/logo_header.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/youtube_videos_state.dart';

class YoutubeHomeTopBar extends StatelessWidget {
  const YoutubeHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideosCubit, YoutubeVideosState>(
      buildWhen: (previous, current) => previous.searchQuery != current.searchQuery,
      builder: (_, state) {
        if (state.searchQuery.isEmpty) {
          return const _NoSearchQueryView();
        }

        return _SearchQueryTopBar(
          searchQuery: state.searchQuery,
        );
      },
    );
  }
}

class _NoSearchQueryView extends StatelessWidget {
  const _NoSearchQueryView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        const LogoHeaderMedium(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: context.youtubeVideosCubit.onSearchPressed,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.primaryContainer,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svgSearch,
                  width: 15,
                  height: 15,
                  colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
                ),
                const SizedBox(width: 6),
                Text(
                  l.searchDots,
                  style: TextStyle(
                    color: theme.appThemeExtension?.elSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchQueryTopBar extends StatelessWidget {
  const _SearchQueryTopBar({
    required this.searchQuery,
  });

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoHeaderSmall(),
          GestureDetector(
            onTap: context.youtubeVideosCubit.onSearchPressed,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 2, 4, 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: theme.colorScheme.primaryContainer,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.svgSearch,
                    width: 15,
                    height: 15,
                    colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: mediaQuery.size.width * 0.3,
                    ),
                    child: Text(
                      searchQuery,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: context.youtubeVideosCubit.onClearSearch,
                    splashRadius: 20,
                    icon: SvgPicture.asset(
                      Assets.svgX,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
