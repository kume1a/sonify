import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({
    super.key,
    this.itemPadding,
  });

  final EdgeInsets? itemPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: SmallCircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => _Item(
              audio: data[index],
              padding: itemPadding,
            ),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.audio,
    required this.padding,
  });

  final Audio audio;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
      builder: (_, nowPlayingAudioState) {
        final nowPlayingAudio = nowPlayingAudioState.nowPlayingAudio.getOrNull;

        final isPlaying = nowPlayingAudio?.id != null && nowPlayingAudio?.id == audio.id;

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onLocalAudioPressed(audio),
          audio: audio,
          isPlaying: isPlaying,
          padding: padding,
        );
      },
    );
  }
}
