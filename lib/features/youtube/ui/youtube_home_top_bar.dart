import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/ui/logo_header.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/youtube_videos_state.dart';

class YoutubeHomeTopBar extends StatelessWidget {
  const YoutubeHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoHeaderSmall(),
          BlocBuilder<YoutubeVideosCubit, YoutubeVideosState>(
            buildWhen: (previous, current) => previous.searchQuery != current.searchQuery,
            builder: (_, state) {
              if (state.searchQuery.isEmpty) {
                return IconButton(
                  onPressed: context.youtubeVideosCubit.onSearchPressed,
                  splashRadius: 24,
                  icon: SvgPicture.asset(
                    Assets.svgSearch,
                    width: 24,
                    height: 24,
                  ),
                );
              }

              return GestureDetector(
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
                      Text(state.searchQuery),
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: context.youtubeVideosCubit.onClearSearch,
                        splashRadius: 24,
                        icon: SvgPicture.asset(
                          Assets.svgX,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
