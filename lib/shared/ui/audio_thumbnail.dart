import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../values/assets.dart';

class AudioThumbnail extends HookWidget {
  const AudioThumbnail({
    super.key,
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.dimension,
    this.borderRadius = BorderRadius.zero,
  });

  final String? thumbnailPath;
  final String? thumbnailUrl;
  final double dimension;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final imageFile = useMemoized<File?>(
      () => thumbnailPath != null ? File(thumbnailPath!) : null,
    );

    if (thumbnailUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl!,
          width: dimension,
          height: dimension,
          errorWidget: (_, __, ___) => _placeholder(theme),
          placeholder: (context, url) => _placeholder(theme),
        ),
      );
    }

    return imageFile == null
        ? _placeholder(theme)
        : ClipRRect(
            borderRadius: borderRadius,
            child: Image.file(
              imageFile,
              width: dimension,
              height: dimension,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(theme),
            ),
          );
  }

  Widget _placeholder(ThemeData theme) {
    final childDimension = max<double>(24, dimension * .3);

    return Container(
      width: dimension,
      height: dimension,
      color: theme.colorScheme.secondaryContainer,
      child: Align(
        child: SvgPicture.asset(
          Assets.svgLogoTransparentBg,
          width: childDimension,
          height: childDimension,
        ),
      ),
    );
  }
}
