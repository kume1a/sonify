import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/audio_thumbnail.dart';
import '../../../shared/ui/list_header.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/spotify_playlist_list_state.dart';

class SpotifyPlaylistsList extends StatelessWidget {
  const SpotifyPlaylistsList({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<SpotifyPlaylistListCubit, SpotifyPlaylistListState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (playlists) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListHeader(
                  text: l.playlists,
                  onViewAllPressed:
                      playlists.length > 3 ? context.spotifyPlaylistListCubit.onViewAllPressed : null,
                ),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: playlists.length,
                    itemBuilder: (_, index) => _PlaylistItem(playlist: playlists[index]),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PlaylistItem extends StatelessWidget {
  const _PlaylistItem({
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.spotifyPlaylistListCubit.onPlaylistPressed(playlist),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Thumbnail(
              thumbnailUrl: playlist.thumbnailUrl,
              size: const Size.square(125),
            ),
            const SizedBox(height: 4),
            Text(
              playlist.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'TODO artist names',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: theme.appThemeExtension?.elSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
