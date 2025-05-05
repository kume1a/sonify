import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/dev_tools_state.dart';

class DeleteAllDownloadedUserAudiosDevToolTile extends StatelessWidget {
  const DeleteAllDownloadedUserAudiosDevToolTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return ListTile(
      title: Text(l.deleteAllDownloadedUserAudios),
      onTap: context.read<DevToolsCubit>().onDeleteAllDownloadedUserAudios,
    );
  }
}

class DeleteAllDownloadedPlaylistAudioFilesDevToolTile extends StatelessWidget {
  const DeleteAllDownloadedPlaylistAudioFilesDevToolTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return ListTile(
      title: Text(l.deleteAllDownloadedPlaylistAudioFiles),
      onTap: context.read<DevToolsCubit>().onDeleteAllDownloadedPlaylistAudioFilesPressed,
    );
  }
}
