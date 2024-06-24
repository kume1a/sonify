import 'package:flutter/material.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/local_user_audio_files_state.dart';

class MyLibrarySearchContainer extends StatelessWidget {
  const MyLibrarySearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: context.localAudioFilesCubit.onSearchContainerPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          l.search,
          style: TextStyle(
            color: theme.appThemeExtension?.elSecondary,
          ),
        ),
      ),
    );
  }
}
