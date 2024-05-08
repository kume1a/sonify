import 'package:flutter/material.dart';

import 'play_pause.dart';

class RoundPlayButton extends StatelessWidget {
  const RoundPlayButton({
    super.key,
    required this.size,
    required this.iconSize,
    required this.isPlaying,
    required this.onPressed,
  });

  final double size;
  final double iconSize;
  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      constraints: BoxConstraints.tight(Size.square(size)),
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: PlayPause(
        isPlaying: isPlaying,
        size: iconSize,
      ),
      onPressed: onPressed,
    );
  }
}
