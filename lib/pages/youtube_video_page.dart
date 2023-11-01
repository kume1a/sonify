import 'package:flutter/material.dart';

class YoutubeVideoPageArgs {
  YoutubeVideoPageArgs({
    required this.videoId,
  });

  final String videoId;
}

class YoutubeVideoPage extends StatelessWidget {
  const YoutubeVideoPage({
    super.key,
    required this.args,
  });

  final YoutubeVideoPageArgs args;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
