import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

import '../state/youtube_videos_state.dart';

class YoutubeVideoListItem extends StatelessWidget {
  const YoutubeVideoListItem({
    super.key,
    this.videoId,
    required this.imageUrl,
    required this.title,
  });

  final String? videoId;
  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final w = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: SafeImage(
              url: imageUrl,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );

    return videoId == null
        ? w
        : InkWell(
            onTap: () => context.youtubeVideosCubit.onVideoPressed(videoId!),
            child: w,
          );
  }
}
