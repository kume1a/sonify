import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/audio_thumbnail.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../model/local_audio_file.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          success: (data) => SliverList.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => _Item(localAudioFile: data[index]),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.localAudioFile,
  });

  final LocalAudioFile localAudioFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.localAudioFilesCubit.onLocalAudioFilePressed(localAudioFile),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (localAudioFile.thumbnailPath != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AudioThumbnail(
                  thumbnailPath: localAudioFile.thumbnailPath,
                  borderRadius: BorderRadius.circular(8),
                  dimension: 36,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localAudioFile.title),
                  const SizedBox(height: 4),
                  Text(
                    localAudioFile.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.appThemeExtension?.elSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
