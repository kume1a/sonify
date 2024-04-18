import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/color.dart';
import '../../values/app_theme_extension.dart';
import '../../values/assets.dart';
import '../thumbnail.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({
    super.key,
    required this.onTap,
    required this.audio,
    required this.isPlaying,
  });

  final VoidCallback onTap;
  final Audio audio;
  final bool isPlaying;

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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audio.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPlaying ? theme.colorScheme.secondary : null,
                          ),
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
                  if (isPlaying)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SvgPicture.asset(
                        Assets.svgAudioLines,
                        width: 16,
                        height: 16,
                        colorFilter: svgColor(theme.colorScheme.secondary),
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
