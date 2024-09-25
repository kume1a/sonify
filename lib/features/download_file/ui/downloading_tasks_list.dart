import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/equality.dart';
import '../../../shared/util/formatting.dart';
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
            task: state.downloading[index],
          ),
        );
      },
    );
  }
}

class _QueueItem extends StatelessWidget {
  const _QueueItem({
    required this.task,
  });

  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final formattedProgress = '${task.progress.toStringAsFixed(1)}%';
    final formattedSpeed = formatBitrateLocalized(task.speedInBytesPerSecond, l);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.payload.hasImage)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Thumbnail(
                size: const Size.square(36),
                borderRadius: BorderRadius.circular(8),
                localThumbnailPath: task.payload.audioLocalThumbnailPath,
                thumbnailPath: task.payload.audioThumbnailPath,
                thumbnailUrl: task.payload.audioThumbnailUrl,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.payload.audioTitle ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(formattedProgress),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              formattedSpeed,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
