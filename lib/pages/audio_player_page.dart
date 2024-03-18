import 'package:flutter/material.dart';

import '../features/play_audio/ui/audio_player_controls.dart';
import '../features/play_audio/ui/audio_player_header.dart';
import '../features/play_audio/ui/audio_player_image.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

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
