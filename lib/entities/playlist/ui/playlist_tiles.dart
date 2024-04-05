import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/assets.dart';

class PlaylistTiles extends StatelessWidget {
  const PlaylistTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      crossAxisCount: 2,
      childAspectRatio: 170 / 42,
      crossAxisSpacing: 6,
      shrinkWrap: true,
      children: const [
        _MyLibraryPlaylistTile(),
        _LikedSongsPlaylistTile(),
      ],
    );
  }
}

class _MyLibraryPlaylistTile extends StatelessWidget {
  const _MyLibraryPlaylistTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return _PlaylistTile(
      image: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(Assets.svgMusicNote),
        ),
      ),
      name: l.myLibrary,
    );
  }
}

class _LikedSongsPlaylistTile extends StatelessWidget {
  const _LikedSongsPlaylistTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return _PlaylistTile(
      image: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(Assets.svgHeart),
        ),
      ),
      name: l.likedSongs,
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({
    required this.image,
    required this.name,
  });

  final Widget image;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          image,
          const SizedBox(width: 6),
          Text(name),
        ],
      ),
    );
  }
}
