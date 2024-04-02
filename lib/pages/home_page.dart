import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/audio/state/local_audio_files_state.dart';
import '../entities/audio/ui/local_audio_files.dart';
import '../features/download_file/ui/downloads_list.dart';
import '../features/spotifyauth/state/spotify_auth_state.dart';
import '../features/spotifyauth/ui/auth_spotify_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocalAudioFilesCubit>()),
        BlocProvider(create: (_) => getIt<SpotifyAuthCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyAuthCubit, SpotifyAuthState>(
      builder: (context, state) {
        return state.isSpotifyAuthenticated.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (isSpotifyAuthenticated) {
            if (isSpotifyAuthenticated) {
              return const CustomScrollView(
                slivers: [
                  DownloadsList(),
                  LocalAudioFiles(),
                ],
              );
            }

            return const Center(
              child: AuthSpotifyButton(),
            );
          },
        );
      },
    );
  }
}
