import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/search_container.dart';
import '../state/playlist_state.dart';

class PlaylistSearchContainer extends StatelessWidget {
  const PlaylistSearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        if (!state.isPlaylistPlayable) {
          return const SizedBox();
        }

        return SearchContainer(
          onPressed: context.playlistCubit.onSearchContainerPressed,
        );
      },
    );
  }
}
