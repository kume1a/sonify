import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../util/assemble_resource_url.dart';
import '../util/utils.dart';
import '../values/assets.dart';

class Thumbnail extends HookWidget {
  const Thumbnail({
    super.key,
    this.thumbnailPath,
    this.thumbnailUrl,
    this.localThumbnailPath,
    required this.size,
    this.borderRadius = BorderRadius.zero,
  }) : assert(
          thumbnailPath != null || thumbnailUrl != null || localThumbnailPath != null,
          'Either thumbnailPath, thumbnailUrl or localThumbnailPath must be provided',
        );

  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String? localThumbnailPath;
  final Size size;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final imageFile = useMemoized<File?>(
      () => localThumbnailPath.notNullOrEmpty ? File(localThumbnailPath!) : null,
    );

    if (imageFile != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          imageFile,
          width: size.width,
          height: size.height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(theme),
        ),
      );
    }

    final url = thumbnailUrl.notNullOrEmpty
        ? thumbnailUrl!
        : thumbnailPath.notNullOrEmpty
            ? assembleResourceUrl(thumbnailPath!)
            : null;

    return url != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
              errorWidget: (_, __, err) => _placeholder(theme),
              placeholder: (context, url) => _placeholder(theme),
            ),
          )
        : _placeholder(theme);
  }

  Widget _placeholder(ThemeData theme) {
    final childDimension = max<double>(24, size.width * .25);

    return Container(
      width: size.width,
      height: size.height,
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
