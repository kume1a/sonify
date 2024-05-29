import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
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
    const padding = EdgeInsets.fromLTRB(16, 48, 16, 16);

    return BlocBuilder<ImportSpotifyPlaylistsCubit, ImportSpotifyPlaylistsState>(
      buildWhen: (previous, current) =>
          previous.isSpotifyPlaylistsImported != current.isSpotifyPlaylistsImported,
      builder: (_, state) {
        return state.isSpotifyPlaylistsImported.maybeWhen(
          orElse: () => const Padding(
            padding: padding,
            child: Center(child: SmallCircularProgressIndicator()),
          ),
          failure: (_) => _ImportSpotifyPlaylistsFailed(
            onRefresh: context.importSpotifyPlaylistsCubit.onRefreshSpotifyPlaylistImportStatus,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
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
          ),
          executing: () => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
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
          ),
          failed: (_) => _ImportSpotifyPlaylistsFailed(
            onRefresh: context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
          ),
          executed: () => onImportSuccess,
        );
      },
    );
  }
}

class _ImportSpotifyPlaylistsFailed extends StatelessWidget {
  const _ImportSpotifyPlaylistsFailed({
    super.key,
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.failedToImportSpotifyPlaylists,
              style: TextStyle(color: theme.appThemeExtension?.elSecondary),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onRefresh,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(8),
              ),
              child: Text(l.retry),
            ),
          ],
        ),
      ),
    );
  }
}
