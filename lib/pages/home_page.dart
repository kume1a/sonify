import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/playlist/state/import_spotify_playlists_state.dart';
import '../entities/playlist/state/spotify_playlist_list_state.dart';
import '../entities/playlist/ui/ensure_spotify_playlists_imported.dart';
import '../entities/playlist/ui/playlist_tiles.dart';
import '../entities/playlist/ui/spotify_playlists_list.dart';
import '../features/spotifyauth/state/spotify_auth_state.dart';
import '../features/spotifyauth/ui/auth_spotify_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SpotifyAuthCubit>()),
        BlocProvider(create: (_) => getIt<SpotifyPlaylistListCubit>()),
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
    return BlocBuilder<SpotifyAuthCubit, SpotifyAuthState>(
      builder: (context, state) {
        return state.isSpotifyAuthenticated.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (isSpotifyAuthenticated) {
            if (isSpotifyAuthenticated) {
              return EnsureSpotifyPlaylistsImported(
                child: ListView(
                  children: const [
                    SizedBox(height: 24),
                    PlaylistTiles(),
                    SpotifyPlaylistsList(),
                  ],
                ),
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
