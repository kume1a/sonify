import 'package:flutter/material.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/import_local_music_state.dart';

class SubmitImportLocalMusicButton extends StatelessWidget {
  const SubmitImportLocalMusicButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return TextButton(
      onPressed: context.importLocalMusicCubit.onSubmit,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: Text(l.submit),
    );
  }
}
