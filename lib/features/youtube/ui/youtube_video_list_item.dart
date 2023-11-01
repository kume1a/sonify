import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class YoutubeVideoListItem extends StatelessWidget {
  const YoutubeVideoListItem({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
  }
}
