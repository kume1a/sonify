import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/ui/list_header.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/values/assets.dart';
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
                    itemBuilder: (_, __) => const _ItemBlank(),
                    itemCount: 10,
                  ),
                ),
                success: (playlists) {
                  if (playlists.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(l.noPlaylistsFound),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: context.playlistListCubit.onCreatePlaylistPressed,
                          child: Text(l.createPlaylist),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: playlists.length + 1,
                    itemBuilder: (_, index) {
                      if (index == playlists.length) {
                        return const _ItemNewPlaylist();
                      }

                      return _Item(userPlaylist: playlists[index]);
                    },
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

class _ItemNewPlaylist extends StatelessWidget {
  const _ItemNewPlaylist();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return InkWell(
      onTap: context.playlistListCubit.onCreatePlaylistPressed,
      borderRadius: BorderRadius.circular(8),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 125,
          height: 125,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 20),
              SizedBox(height: 4),
              Text(
                l.createPlaylist,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemBlank extends StatelessWidget {
  const _ItemBlank();

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

class _Item extends StatelessWidget {
  const _Item({
    required this.userPlaylist,
  });

  final UserPlaylist userPlaylist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    final playlist = userPlaylist.playlist;
    if (playlist == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => context.playlistListCubit.onPlaylistPressed(userPlaylist),
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
                        ProcessStatus.pending => Center(
                            child: Text(
                              l.pending,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ProcessStatus.processing => PulsingFade(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l.importing,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${playlist.audioCount}/${playlist.totalAudioCount}',
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
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
            Row(
              children: [
                Flexible(
                  child: Text(
                    playlist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (userPlaylist.isSpotifySavedPlaylist)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: SvgPicture.asset(Assets.svgSpotify, width: 15, height: 15),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
