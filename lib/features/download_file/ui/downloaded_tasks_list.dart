import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class _Item extends HookWidget {
  const _Item({
    required this.task,
  });

  final DownloadedTask task;

  @override
  Widget build(BuildContext context) {
    String title = '';
    String? localThumbnailPath;
    String? thumbnailPath;
    String? thumbnailUrl;

    switch (task.fileType) {
      case FileType.audioMp3:
        localThumbnailPath = task.payload.userAudio?.audio?.localThumbnailPath;
        thumbnailPath = task.payload.userAudio?.audio?.thumbnailPath;
        thumbnailUrl = task.payload.userAudio?.audio?.thumbnailUrl;
        title = task.payload.userAudio?.audio?.title ?? '';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localThumbnailPath != null || thumbnailPath != null || thumbnailUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Thumbnail(
                size: const Size.square(36),
                localThumbnailPath: localThumbnailPath,
                thumbnailPath: thumbnailPath,
                thumbnailUrl: thumbnailUrl,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
