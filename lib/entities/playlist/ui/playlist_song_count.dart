import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/playlist_state.dart';

class PlaylistSongCount extends StatelessWidget {
  const PlaylistSongCount({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        final itemCount = state.playlist.maybeWhen(
          orElse: () => 0,
          success: (playlist) => playlist.playlistAudios?.length ?? 0,
        );

        return Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 2.h),
          child: Text(
            l.songsCount(itemCount),
            style: TextStyle(
              fontSize: 11.sp,
              color: theme.appThemeExtension?.elSecondary,
            ),
          ),
        );
      },
    );
  }
}
