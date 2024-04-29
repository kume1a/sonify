import 'package:domain_data/domain_data.dart';
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
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.audios?.length ?? 0,
            itemBuilder: (_, index) {
              final audio = data.audios?.elementAt(index);
              if (audio == null) {
                return const SizedBox.shrink();
              }

              return _Item(
                audio: audio,
                playlistId: playlistId,
              );
            },
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.audio,
    required this.playlistId,
  });

  final Audio audio;
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
      builder: (_, nowPlayingAudioState) {
        final nowPlayingAudio = nowPlayingAudioState.nowPlayingAudio.getOrNull;

        final isPlaying = (nowPlayingAudio?.id != null && nowPlayingAudio?.id == audio.id) ||
            (nowPlayingAudio?.localId != null && nowPlayingAudio?.localId == audio.localId);

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onPlaylistAudioPressed(
            audio: audio,
            playlistId: playlistId,
          ),
          audio: audio,
          isPlaying: isPlaying,
        );
      },
    );
  }
}
