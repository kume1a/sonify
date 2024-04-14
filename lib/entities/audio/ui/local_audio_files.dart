import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              final localAudioFile = data[index];

              return AudioListItem(
                onTap: () => context.nowPlayingAudioCubit.onLocalAudioPressed(localAudioFile.audio),
                thumbnailPath: localAudioFile.audio?.thumbnailPath,
                title: localAudioFile.audio?.title ?? '',
                author: localAudioFile.audio?.author ?? '',
              );
            },
          ),
        );
      },
    );
  }
}
