import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/typedefs.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/playlist_tiles_state.dart';

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
  const _MyLibraryPlaylistTile();

  @override
  Widget build(BuildContext context) {
    return _StaticPlaylistTile(
      name: (l) => l.myLibrary,
      iconAssetName: Assets.svgMusicNote,
      onPressed: context.playlistTilesCubit.onMyLibraryPressed,
    );
  }
}

class _LikedSongsPlaylistTile extends StatelessWidget {
  const _LikedSongsPlaylistTile();

  @override
  Widget build(BuildContext context) {
    return _StaticPlaylistTile(
      name: (l) => l.likedSongs,
      iconAssetName: Assets.svgHeart,
      onPressed: null,
    );
  }
}

class _StaticPlaylistTile extends StatelessWidget {
  const _StaticPlaylistTile({
    required this.name,
    required this.iconAssetName,
    required this.onPressed,
  });

  final LocalizedStringResolver name;
  final String iconAssetName;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    final isDisabled = onPressed == null;

    return _PlaylistTile(
      onPressed: onPressed,
      image: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconAssetName,
            colorFilter:
                svgColor(isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onSecondary),
          ),
        ),
      ),
      name: Text(
        name(l),
        style: TextStyle(
          color: isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onSecondary,
        ),
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({
    required this.image,
    required this.name,
    required this.onPressed,
  });

  final Widget image;
  final Widget name;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            image,
            const SizedBox(width: 6),
            name,
          ],
        ),
      ),
    );
  }
}
