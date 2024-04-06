import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

import '../../util/utils.dart';
import '../../values/app_theme_extension.dart';
import '../audio_thumbnail.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({
    super.key,
    required this.onTap,
    this.thumbnailPath,
    this.thumbnailUrl,
    required this.title,
    required this.author,
  });

  final VoidCallback onTap;
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (thumbnailPath != null || thumbnailUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: thumbnailPath.notNullOrEmpty
                    ? AudioThumbnail(
                        thumbnailPath: thumbnailPath,
                        borderRadius: BorderRadius.circular(8),
                        dimension: 36,
                      )
                    : thumbnailUrl.notNullOrEmpty
                        ? SafeImage(
                            url: thumbnailUrl,
                            width: 36,
                            height: 36,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : const SizedBox.shrink(),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 4),
                  Text(
                    author,
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
