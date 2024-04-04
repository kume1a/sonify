import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
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
          orElse: () => const CircularProgressIndicator(),
          failure: (l) => IconButton(
            onPressed: context.importSpotifyPlaylistsCubit.onRefreshSpotifyPlaylistImportStatus,
            icon: const Icon(Icons.refresh),
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

    return BlocBuilder<ImportSpotifyPlaylistsCubit, ImportSpotifyPlaylistsState>(
      buildWhen: (previous, current) =>
          previous.importSpotifyPlaylistsState != current.importSpotifyPlaylistsState,
      builder: (_, state) {
        return state.importSpotifyPlaylistsState.maybeWhen(
          orElse: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.importingSpotifyPlaylists),
              const SizedBox(height: 10),
              const CircularProgressIndicator(),
            ],
          ),
          failed: (l) => IconButton(
            onPressed: context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
            icon: const Icon(Icons.refresh),
          ),
          executed: () => onImportSuccess,
        );
      },
    );
  }
}
