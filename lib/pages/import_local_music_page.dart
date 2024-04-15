import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../features/import_local_music/state/import_local_music_state.dart';
import '../features/import_local_music/ui/imported_local_music_list.dart';
import '../shared/ui/default_back_button.dart';

class ImportLocalMusicPage extends StatelessWidget {
  const ImportLocalMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ImportLocalMusicCubit>(),
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
        title: Text(l.importLocalMusic),
        leading: const DefaultBackButton(),
        titleTextStyle: const TextStyle(fontSize: 14),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ImportedLocalMusicList(),
      ),
    );
  }
}
