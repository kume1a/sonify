import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/equality.dart';
import '../state/downloads_state.dart';

class DownloadedTasksList extends StatelessWidget {
  const DownloadedTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadsCubit, DownloadsState>(
      buildWhen: (previous, current) => notDeepEquals(previous.downloaded, current.downloaded),
      builder: (_, state) {
        if (state.downloaded.isEmpty) {
          return const SliverToBoxAdapter();
        }

        return SliverList.builder(
          itemCount: state.downloaded.length,
          itemBuilder: (_, index) => _Item(
            task: state.downloaded[index],
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.task,
  });

  final DownloadedTask task;

  @override
  Widget build(BuildContext context) {
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
                localThumbnailPath: task.payload.audioLocalThumbnailPath,
                thumbnailPath: task.payload.audioThumbnailPath,
                thumbnailUrl: task.payload.audioThumbnailUrl,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          Expanded(
            child: Text(task.payload.audioTitle ?? ''),
          ),
        ],
      ),
    );
  }
}
