import 'package:common_widgets/common_widgets.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../entities/audio/util/audio_extension.dart';
import '../../../shared/util/equality.dart';
import '../state/downloads_state.dart';

class DownloadingTasksList extends StatelessWidget {
  const DownloadingTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadsCubit, DownloadsState>(
      buildWhen: (previous, current) => notDeepEquals(previous.downloading, current.downloading),
      builder: (_, state) {
        if (state.downloading.isEmpty) {
          return const SliverToBoxAdapter();
        }

        return SliverList.builder(
          itemCount: state.downloading.length,
          itemBuilder: (_, index) => _QueueItem(
            downloadTask: state.downloading[index],
          ),
        );
      },
    );
  }
}

class _QueueItem extends HookWidget {
  const _QueueItem({
    required this.downloadTask,
  });

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    String title = '';
    Uri? imageUri;

    switch (downloadTask.fileType) {
      case FileType.audioMp3:
        imageUri = downloadTask.payload.userAudio?.audio?.thumbnailUri;
        title = downloadTask.payload.userAudio?.audio?.title ?? '';
        break;
    }

    final progress = downloadTask.progress.toStringAsFixed(2);
    final speed = downloadTask.speedInKbs.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUri != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SafeImage(
                url: imageUri.toString(),
                width: 36,
                height: 36,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text('$progress%'),
              ],
            ),
          ),
          Text('${speed}kb/s'),
        ],
      ),
    );
  }
}
