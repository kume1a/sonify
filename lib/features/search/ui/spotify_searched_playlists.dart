import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/animation/pulsing_fade.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/random.dart';
import '../state/spotify_search_state.dart';

class SpotifySearchedPlaylists extends StatelessWidget {
  const SpotifySearchedPlaylists({super.key});

  static const _height = 160.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifySearchCubit, SpotifySearchState>(
      builder: (_, state) => state.maybeWhen(
        loading: () => PulsingFade(
          child: SizedBox(
            height: _height,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (_, index) => const _BlankItem(),
            ),
          ),
        ),
        success: (data) => SizedBox(
          height: _height,
          child: _Content(data),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.data);

  final SpotifySearchResult data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.playlists.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (_, index) => _PlaylistItem(playlist: data.playlists[index]),
    );
  }
}

class _BlankItem extends StatelessWidget {
  const _BlankItem();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 100,
            height: 10,
            color: theme.colorScheme.secondaryContainer,
          ),
          if (randomInt(0, 10) > 3)
            Container(
              width: randomDouble(50, 100),
              height: 10,
              margin: const EdgeInsets.only(top: 2),
              color: theme.colorScheme.secondaryContainer,
            ),
        ],
      ),
    );
  }
}

class _PlaylistItem extends StatelessWidget {
  const _PlaylistItem({
    required this.playlist,
  });

  final SpotifySearchResultPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.spotifySearchCubit.onSearchedPlaylistPressed(playlist),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Thumbnail(
              thumbnailUrl: playlist.imageUrl,
              size: const Size.square(100),
            ),
            const SizedBox(height: 5),
            Text(
              playlist.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
