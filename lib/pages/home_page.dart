import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../entities/playlist/state/playlist_list_state.dart';
import '../entities/playlist/state/playlist_tiles_state.dart';
import '../entities/playlist/ui/playlist_list.dart';
import '../entities/playlist/ui/playlist_tiles.dart';
import '../features/spotifyauth/state/spotify_auth_state.dart';
import '../features/spotifyauth/ui/auth_spotify_button.dart';
import '../shared/values/app_theme_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SpotifyAuthCubit>()),
        BlocProvider(create: (_) => getIt<PlaylistListCubit>()),
        BlocProvider(create: (_) => getIt<PlaylistTilesCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<SpotifyAuthCubit, SpotifyAuthState>(
      builder: (_, state) {
        return state.isSpotifyAuthenticated.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (isSpotifyAuthenticated) {
            return RefreshIndicator(
              onRefresh: context.playlistListCubit.onRefresh,
              child: ListView(
                children: [
                  const SizedBox(height: 24),
                  const PlaylistTiles(),
                  if (isSpotifyAuthenticated)
                    const PlaylistsList()
                  else
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.authorizeSpotifyCaption,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.appThemeExtension?.elSecondary),
                          ),
                          const SizedBox(height: 6),
                          const AuthSpotifyButton(),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
