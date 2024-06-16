import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/thumbnail.dart';
import '../state/spotify_search_state.dart';

class SpotifySearchedPlaylists extends StatelessWidget {
  const SpotifySearchedPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BlocBuilder<SpotifySearchCubit, SpotifySearchState>(
        builder: (_, state) => state.maybeWhen(
          success: (data) => _Content(data),
          orElse: () => const SizedBox.shrink(),
        ),
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
