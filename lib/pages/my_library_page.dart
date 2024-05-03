import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../entities/audio/state/local_audio_files_state.dart';
import '../entities/audio/ui/local_audio_files.dart';
import '../entities/audio/ui/local_audio_files_alphabet.dart';
import '../entities/playlist/ui/my_library_header.dart';
import '../entities/playlist/ui/my_library_tiles.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../shared/ui/default_back_button.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocalAudioFilesCubit>()),
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

    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Scaffold(
      body: SafeArea(
        child: AudioPlayerPanel(
          body: Column(
            children: [
              Padding(
                padding: padding.copyWith(left: 4, top: 20),
                child: Row(
                  children: [
                    const DefaultBackButton(),
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        onChanged: context.localAudioFilesCubit.onSearchQueryChanged,
                        decoration: InputDecoration(
                          hintText: l.search,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: LocalAudioFilesAlphabet(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: padding,
                        sliver: SliverToBoxAdapter(
                          child: MyLibraryTiles(),
                        ),
                      ),
                      SliverSizedBox(height: 20),
                      SliverPadding(
                        padding: padding,
                        sliver: SliverToBoxAdapter(
                          child: MyLibraryHeader(),
                        ),
                      ),
                      SliverSizedBox(height: 16),
                      LocalAudioFiles(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
