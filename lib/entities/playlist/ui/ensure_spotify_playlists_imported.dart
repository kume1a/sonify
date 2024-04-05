import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/import_spotify_playlists_state.dart';

class EnsureSpotifyPlaylistsImported extends StatelessWidget {
  const EnsureSpotifyPlaylistsImported({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportSpotifyPlaylistsCubit, ImportSpotifyPlaylistsState>(
      buildWhen: (previous, current) =>
          previous.isSpotifyPlaylistsImported != current.isSpotifyPlaylistsImported,
      builder: (_, state) {
        return state.isSpotifyPlaylistsImported.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          failure: (l) => Center(
            child: IconButton(
              onPressed: context.importSpotifyPlaylistsCubit.onRefreshSpotifyPlaylistImportStatus,
              icon: const Icon(Icons.refresh),
            ),
          ),
          success: (isSpotifyPlaylistsImported) {
            if (isSpotifyPlaylistsImported) {
              return child;
            }

            return _ImportSpotifyPlaylistsFlow(
              onImportSuccess: child,
            );
          },
        );
      },
    );
  }
}

class _ImportSpotifyPlaylistsFlow extends StatelessWidget {
  const _ImportSpotifyPlaylistsFlow({
    required this.onImportSuccess,
  });

  final Widget onImportSuccess;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<ImportSpotifyPlaylistsCubit, ImportSpotifyPlaylistsState>(
      buildWhen: (previous, current) =>
          previous.importSpotifyPlaylistsState != current.importSpotifyPlaylistsState,
      builder: (_, state) {
        return state.importSpotifyPlaylistsState.when(
          idle: () => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.importSpotifyPlaylists),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
                  child: Text(l.import),
                ),
              ],
            ),
          ),
          executing: () => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.importingSpotifyPlaylists),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l.importingSpotifyPlaylistsSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.appThemeExtension?.elSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
          failed: (_) => Center(
            child: IconButton(
              onPressed: context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
              icon: const Icon(Icons.refresh),
            ),
          ),
          executed: () => onImportSuccess,
        );
      },
    );
  }
}
