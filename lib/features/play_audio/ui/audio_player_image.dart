import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';
import '../state/audio_player_state.dart';

class AudioPlayerImage extends StatelessWidget {
  const AudioPlayerImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return SizedBox.square(
            dimension: constraints.maxWidth * 0.75,
            child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
              buildWhen: (previous, current) => previous.currentSong != current.currentSong,
              builder: (_, state) {
                return state.currentSong.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  success: (data) {
                    return Image.asset(
                      data.thumbnailPath ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: theme.colorScheme.primaryContainer,
                          child: Align(
                            child: SvgPicture.asset(
                              Assets.svgLogoTransparentBg,
                              width: 52,
                              height: 52,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
