import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/util/equality.dart';
import '../model/download_task.dart';
import '../state/downloads_state.dart';

class DownloadsList extends StatelessWidget {
  const DownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadsCubit, DownloadsState>(
      buildWhen: (previous, current) => notDeepEquals(previous.queue, current.queue),
      builder: (_, state) {
        final queueList = List.of(state.queue);

        return SliverList.builder(
          itemCount: state.queue.length,
          itemBuilder: (_, index) => _QueueItem(
            downloadTask: queueList[index],
          ),
        );
      },
    );
  }
}

class _QueueItem extends StatelessWidget {
  const _QueueItem({
    required this.downloadTask,
  });

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(downloadTask.progress.toString()),
    );
  }
}
