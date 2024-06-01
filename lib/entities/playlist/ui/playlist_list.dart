import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/ui/list_header.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/playlist_list_state.dart';

class PlaylistsList extends StatelessWidget {
  const PlaylistsList({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListHeader(text: l.playlists),
        SizedBox(
          height: 190,
          child: BlocBuilder<PlaylistListCubit, PlaylistListState>(
            builder: (_, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                loading: () => PulsingFade(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (_, __) => const _PlaylistItemBlank(),
                    itemCount: 3,
                  ),
                ),
                success: (playlists) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: playlists.length,
                    itemBuilder: (_, index) => _PlaylistItem(playlist: playlists[index]),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class _PlaylistItemBlank extends StatelessWidget {
  const _PlaylistItemBlank({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
    final l = AppLocalizations.of(context);

    final isImportCompleted = playlist.audioImportStatus == ProcessStatus.completed;

    return InkWell(
      onTap: isImportCompleted ? () => context.spotifyPlaylistListCubit.onPlaylistPressed(playlist) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Thumbnail(
                  thumbnailUrl: playlist.thumbnailUrl,
                  thumbnailPath: playlist.thumbnailPath,
                  size: const Size.square(125),
                ),
                if (playlist.audioImportStatus != null &&
                    playlist.audioImportStatus != ProcessStatus.completed)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: switch (playlist.audioImportStatus) {
                        ProcessStatus.pending => const Center(
                            child: SmallCircularProgressIndicator(),
                          ),
                        ProcessStatus.processing => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SmallCircularProgressIndicator(),
                              const SizedBox(height: 4),
                              Text(
                                '${playlist.audioCount}/${playlist.totalAudioCount}',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ProcessStatus.failed => Center(
                            child: Text(
                              l.importFailed,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  ),
              ],
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
