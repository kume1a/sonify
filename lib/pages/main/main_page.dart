import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/register_dependencies.dart';
import '../../entities/playlist/state/import_spotify_playlists_state.dart';
import '../../features/play_audio/state/audio_player_panel_state.dart';
import '../../features/play_audio/ui/audio_player_panel.dart';
import '../../features/sync_user_data/state/sync_user_data_state.dart';
import '../../features/sync_user_data/ui/sync_user_data_indicator.dart';
import 'state/main_page_state.dart';
import 'ui/main_navigation_bar.dart';
import 'ui/page_content.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
        BlocProvider(create: (_) => getIt<MainPageCubit>()),
        BlocProvider(create: (_) => getIt<SyncUserDataCubit>(), lazy: false),
        BlocProvider(create: (_) => getIt<ImportSpotifyPlaylistsCubit>()),
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
          body: Stack(
            children: [
              PageContent(),
              Positioned(
                bottom: 18,
                left: 0,
                right: 0,
                child: Align(child: SyncUserDataIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
