import 'package:flutter/material.dart';

import '../app/intl/app_localizations.dart';
import '../features/download_file/ui/download_tasks_list.dart';
import '../features/play_audio/ui/audio_player_panel.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.downloads),
      ),
      body: const AudioPlayerPanel(
        body: SafeArea(
          child: DownloadTasksList(),
        ),
      ),
    );
  }
}
