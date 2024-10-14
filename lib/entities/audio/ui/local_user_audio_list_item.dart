import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';

class LocalUserAudioListItem extends StatelessWidget {
  const LocalUserAudioListItem({
    super.key,
    required this.userAudio,
    this.padding,
    this.onMenuPressed,
  });

  final UserAudio userAudio;
  final EdgeInsets? padding;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) =>
          previous.nowPlayingAudio != current.nowPlayingAudio || previous.playlist != current.playlist,
      builder: (_, state) {
        if (userAudio.audio == null) {
          return const SizedBox();
        }

        final nowPlayingAudio = state.nowPlayingAudio.getOrNull;

        final isPlaying =
            nowPlayingAudio?.id != null && nowPlayingAudio?.id == userAudio.audioId && state.playlist == null;

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onLocalAudioPressed(userAudio),
          audio: userAudio.audio!,
          isPlaying: isPlaying,
          padding: padding,
          onMenuPressed: onMenuPressed,
        );
      },
    );
  }
}
