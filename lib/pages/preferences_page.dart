import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../features/user_preferences/state/user_preferences_state.dart';
import '../features/user_preferences/ui/user_preference_tiles.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<UserPreferencesCubit>()),
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
        title: Text(l.preferences),
      ),
      body: SafeArea(
        child: AudioPlayerPanel(
          body: ListView(
            children: const [
              SaveShuffleStatePreferenceTile(),
              SaveRepeatStatePreferenceTile(),
              EnableSearchHistoryPreferenceTile(),
            ],
          ),
        ),
      ),
    );
  }
}
