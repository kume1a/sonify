import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/playlist_state.dart';

class PlaylistItems extends StatelessWidget {
  const PlaylistItems({
    super.key,
    required this.playlistId,
  });

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          success: (data) => SliverList.builder(
            itemCount: data.audios?.length ?? 0,
            itemBuilder: (_, index) {
              final audio = data.audios?.elementAt(index);
              if (audio == null) {
                return const SizedBox.shrink();
              }

              return AudioListItem(
                onTap: () => context.nowPlayingAudioCubit.onPlaylistAudioPressed(
                  audio: audio,
                  playlistId: playlistId,
                ),
                title: audio.title,
                author: audio.author,
                thumbnailUrl: audio.thumbnailUrl,
                thumbnailPath: audio.thumbnailPath,
              );
            },
          ),
        );
      },
    );
  }
}
