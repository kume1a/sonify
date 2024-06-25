import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/playlist_state.dart';
import 'playlist_list_item.dart';

class PlaylistItems extends StatelessWidget {
  const PlaylistItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) {
            final len = data.playlistAudios?.length ?? 0;

            return SliverList.builder(
              itemCount: len + 1,
              itemBuilder: (_, index) {
                // bottom padding
                if (index == len) {
                  return SizedBox(height: AudioListItem.height + 12.h);
                }

                final playlistAudio = data.playlistAudios?.elementAt(index);
                if (playlistAudio == null || playlistAudio.audio == null) {
                  return const SizedBox.shrink();
                }

                return PlaylistListItem(
                  playlistAudio: playlistAudio,
                  onMenuPressed: () => context.playlistCubit.onPlaylistAudioMenuPressed(playlistAudio),
                );
              },
            );
          },
        );
      },
    );
  }
}
