import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayPause extends HookWidget {
  const PlayPause({
    super.key,
    required this.isPlaying,
    required this.size,
  });

  final bool isPlaying;
  final double size;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useEffect(
      () {
        if (isPlaying) {
          animationController.forward();
        } else {
          animationController.reverse();
        }

        return null;
      },
      [isPlaying],
    );

    return AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      size: size,
      progress: animationController,
    );
  }
}
