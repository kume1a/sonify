import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../sonify_video_player.dart';
import '../progress_bar.dart';

class SonifyVideoProgressBar extends StatelessWidget {
  SonifyVideoProgressBar(
    this.controller, {
    this.height = kToolbarHeight,
    SonifyVideoPlayerProgressColors? colors,
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    super.key,
  }) : colors = colors ?? SonifyVideoPlayerProgressColors();

  final double height;
  final VideoPlayerController controller;
  final SonifyVideoPlayerProgressColors colors;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return VideoProgressBar(
      controller,
      barHeight: 10,
      handleHeight: 6,
      drawShadow: true,
      colors: colors,
      onDragEnd: onDragEnd,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
    );
  }
}
