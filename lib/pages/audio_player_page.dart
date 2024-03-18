import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/play_audio/state/audio_player_state.dart';
import '../features/play_audio/ui/audio_player_controls.dart';
import '../features/play_audio/ui/audio_player_header.dart';
import '../features/play_audio/ui/audio_player_image.dart';

class AudioPlayerPageArgs {
  const AudioPlayerPageArgs({
    required this.localAudioFileId,
  });

  final int localAudioFileId;
}

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({
    super.key,
    required this.args,
  });

  final AudioPlayerPageArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AudioPlayerCubit>()..init(args.localAudioFileId),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AudioPlayerHeader(),
            Spacer(),
            AudioPlayerImage(),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AudioPlayerControls(),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
