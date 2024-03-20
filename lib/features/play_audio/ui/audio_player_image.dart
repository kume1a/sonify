import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/ui/audio_thumbnail.dart';
import '../state/audio_player_state.dart';

class AudioPlayerImage extends HookWidget {
  const AudioPlayerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          buildWhen: (previous, current) => previous.currentSong != current.currentSong,
          builder: (_, state) {
            return state.currentSong.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              success: (data) => AudioThumbnail(
                dimension: constraints.maxWidth * 0.75,
                thumbnailPath: data.thumbnailPath ?? '',
                borderRadius: BorderRadius.circular(18),
              ),
            );
          },
        );
      },
    );
  }
}
