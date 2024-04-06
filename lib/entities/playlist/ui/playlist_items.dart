import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/playlist_state.dart';

class PlaylistItems extends StatelessWidget {
  const PlaylistItems({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          success: (data) => ListView.builder(
            controller: scrollController,
            itemCount: data.audios?.length ?? 0,
            itemBuilder: (_, index) {
              final audio = data.audios?.elementAt(index);
              if (audio == null) {
                return const SizedBox.shrink();
              }

              return AudioListItem(
                onTap: () => context.playlistCubit.onAudioPressed(audio),
                title: audio.title,
                author: audio.author,
                thumbnailUrl: audio.thumbnailUrl,
                thumbnailPath: audio.thumbnailPath,
              );
            },
          ),
        );
      },
    );
  }
}
