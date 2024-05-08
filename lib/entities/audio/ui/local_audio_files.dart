import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({
    super.key,
    required this.isAlphabetListVisible,
  });

  final bool isAlphabetListVisible;

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
              isAlphabetListVisible: isAlphabetListVisible,
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
    required this.isAlphabetListVisible,
  });

  final Audio audio;
  final bool isAlphabetListVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
      builder: (_, nowPlayingAudioState) {
        final nowPlayingAudio = nowPlayingAudioState.nowPlayingAudio.getOrNull;

        final isPlaying = (nowPlayingAudio?.id != null && nowPlayingAudio?.id == audio.id) ||
            (nowPlayingAudio?.localId != null && nowPlayingAudio?.localId == audio.localId);

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onLocalAudioPressed(audio),
          audio: audio,
          isPlaying: isPlaying,
          padding: EdgeInsets.only(left: 16.r, right: isAlphabetListVisible ? 26.r : 16.r),
        );
      },
    );
  }
}
