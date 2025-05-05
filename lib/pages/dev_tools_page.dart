import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../features/dev_tools/state/dev_tools_state.dart';
import '../features/dev_tools/ui/dev_tools_tiles.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';

class DeveloperToolsPage extends StatelessWidget {
  const DeveloperToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DevToolsCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.developerTools),
      ),
      body: SafeArea(
        child: AudioPlayerPanel(
          body: ListView(
            children: const [
              DeleteAllDownloadedUserAudiosDevToolTile(),
              DeleteAllDownloadedPlaylistAudioFilesDevToolTile(),
            ],
          ),
        ),
      ),
    );
  }
}
