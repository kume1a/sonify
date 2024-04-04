import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/spotify_playlist_list_state.dart';

class SpotifyPlaylistsList extends StatelessWidget {
  const SpotifyPlaylistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyPlaylistListCubit, ImportSpotifyPlaylistListState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const CircularProgressIndicator(),
          success: (playlists) {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                itemBuilder: (_, index) {
                  final playlist = playlists[index];

                  return ListTile(
                    title: Text(playlist.name),
                    onTap: () => context.read<SpotifyPlaylistListCubit>().onPlaylistPressed(playlist),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
