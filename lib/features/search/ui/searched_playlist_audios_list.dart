import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/playlist/ui/playlist_list_item.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/search_playlist_audios_state.dart';

class SearchedPlaylistAudiosList extends StatelessWidget {
  const SearchedPlaylistAudiosList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchPlaylistAudiosCubit, SearchPlaylistAudiosState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const Center(child: SmallCircularProgressIndicator()),
          success: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (_, index) {
                // bottom padding
                if (index == data.length) {
                  return SizedBox(height: AudioListItem.height + 12.h);
                }

                return PlaylistListItem(playlistAudio: data[index]);
              },
            );
          },
        );
      },
    );
  }
}
