import 'package:flutter/material.dart';

import 'play_pause.dart';

class RoundPlayButton extends StatelessWidget {
  const RoundPlayButton({
    super.key,
    required this.size,
    required this.isPlaying,
    required this.onPressed,
  });

  final double size;
  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      constraints: BoxConstraints.tightFor(width: size, height: size),
      alignment: Alignment.center,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: PlayPause(
        isPlaying: isPlaying,
        size: size / 2,
      ),
      onPressed: onPressed,
    );
  }
}
