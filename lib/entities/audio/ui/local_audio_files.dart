import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => _Item(userAudio: data[index]),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.userAudio,
  });

  final UserAudio userAudio;

  @override
  Widget build(BuildContext context) {
    if (userAudio.audio == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
      builder: (_, nowPlayingAudioState) {
        final nowPlayingAudio = nowPlayingAudioState.nowPlayingAudio.getOrNull;

        final isPlaying = nowPlayingAudio?.id == userAudio.audio?.id ||
            nowPlayingAudio?.localId == userAudio.audio?.localId;

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onLocalAudioPressed(userAudio.audio),
          audio: userAudio.audio!,
          isPlaying: isPlaying,
        );
      },
    );
  }
}
