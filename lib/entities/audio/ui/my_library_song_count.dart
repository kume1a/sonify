import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/my_library_audios_state.dart';

class MyLibrarySongCount extends StatelessWidget {
  const MyLibrarySongCount({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<MyLibraryAudiosCubit, MyLibraryAudiosState>(
      builder: (_, state) {
        final itemCount = state.maybeWhen(
          success: (audios) => audios.length,
          orElse: () => 0,
        );

        if (itemCount == 0) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(left: 16.w),
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
