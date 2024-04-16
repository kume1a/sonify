import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';

import '../../values/app_theme_extension.dart';
import '../thumbnail.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({
    super.key,
    required this.onTap,
    required this.audio,
  });

  final VoidCallback onTap;
  final Audio audio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (audio.thumbnailPath != null || audio.thumbnailUrl != null || audio.localThumbnailPath != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Thumbnail(
                  thumbnailPath: audio.thumbnailPath,
                  thumbnailUrl: audio.thumbnailUrl,
                  localThumbnailPath: audio.localThumbnailPath,
                  borderRadius: BorderRadius.circular(8),
                  size: const Size.square(42),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    audio.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.appThemeExtension?.elSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
