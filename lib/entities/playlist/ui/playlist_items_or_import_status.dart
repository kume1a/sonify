import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/playlist_state.dart';
import 'playlist_list_item.dart';

class PlaylistItemsOrImportStatus extends StatelessWidget {
  const PlaylistItemsOrImportStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => PulsingFade.sliver(
            child: SliverList.builder(
              itemCount: 20,
              itemBuilder: (_, __) => const BlankAudioListItem(),
            ),
          ),
          success: (playlist) {
            return playlist.audioImportStatus == ProcessStatus.completed
                ? _PlaylistItems(playlist: playlist)
                : _ImportStatus(playlist: playlist);
          },
        );
      },
    );
  }
}

class _PlaylistItems extends StatelessWidget {
  const _PlaylistItems({
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final len = playlist.playlistAudios?.length ?? 0;

    return SliverList.builder(
      itemCount: len + 1,
      itemBuilder: (_, index) {
        // bottom padding
        if (index == len) {
          return SizedBox(height: AudioListItem.height + 12.h);
        }

        final playlistAudio = playlist.playlistAudios?.elementAt(index);
        if (playlistAudio == null || playlistAudio.audio == null) {
          return const SizedBox.shrink();
        }

        return PlaylistListItem(
          playlistAudio: playlistAudio,
          onMenuPressed: () => context.playlistCubit.onPlaylistAudioMenuPressed(playlistAudio),
        );
      },
    );
  }
}

class _ImportStatus extends StatelessWidget {
  const _ImportStatus({
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return switch (playlist.audioImportStatus) {
      ProcessStatus.processing => PulsingFade.sliver(
          child: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.importingPlaylist),
                const SizedBox(height: 4),
                Text(
                  '${playlist.audioCount}/${playlist.totalAudioCount}',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ProcessStatus.pending => SliverToBoxAdapter(
          child: Center(
            child: Text(l.importSpotifyPlaylistPending),
          ),
        ),
      ProcessStatus.failed => SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                Text(l.failedToImportSpotifyPlaylist),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: context.playlistCubit.onRetryImportPlaylist,
                  child: Text(l.retry),
                ),
              ],
            ),
          ),
        ),
      _ => const SliverToBoxAdapter(),
    };
  }
}
