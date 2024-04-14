import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/register_dependencies.dart';
import '../../features/play_audio/state/audio_player_panel_state.dart';
import '../../features/play_audio/state/audio_player_state.dart';
import '../../features/play_audio/ui/audio_player_panel.dart';
import 'state/main_page_state.dart';
import 'ui/main_navigation_bar.dart';
import 'ui/page_content.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AudioPlayerCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
        BlocProvider(create: (_) => getIt<MainPageCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: MainNavigationBar(),
      body: SafeArea(
        child: AudioPlayerPanel(
          body: PageContent(),
        ),
      ),
    );
  }
}
