import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/equality.dart';
import '../../../shared/util/formatting.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/downloads_state.dart';

class DownloadTasksList extends StatelessWidget {
  const DownloadTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadsCubit, DownloadsState>(
      buildWhen: (previous, current) => notDeepEquals(previous, current),
      builder: (_, state) {
        if (state.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (_, index) => _Item(task: state[index]),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.task,
  });

  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return task.when(
      idle: (id, uri, savePath, fileType, payload) => _DownloadTaskItem(payload: payload),
      failed: (id, uri, savePath, fileType, payload) => _DownloadTaskItem(
          payload: payload,
          caption: Text(
            l.failed,
            style:  TextStyle(color: theme.colorScheme.error),
          ),
          end: IconButton(
            onPressed: () => context.downloadsCubit.retryFailedDownloadTask(task),
            icon: const Icon(Icons.refresh),
          ),
        ),
      completed: (_, __, ___, ____, payload) => _DownloadTaskItem(
        payload: payload,
        end: Icon(Icons.done, color: theme.appThemeExtension?.success),
      ),
      inProgress: (_, __, ___, progress, speedInBytesPerSecond, ____, payload) {
        final formattedProgress = '${progress.toStringAsFixed(1)}%';
        final formattedSpeed = formatBitrateLocalized(speedInBytesPerSecond, l);

        return _DownloadTaskItem(
          payload: payload,
          caption: Text(formattedProgress),
          end: SizedBox(
            width: 72,
            child: Text(
              formattedSpeed,
              textAlign: TextAlign.end,
            ),
          ),
        );
      },
    );
  }
}

class _DownloadTaskItem extends StatelessWidget {
  const _DownloadTaskItem({
    required this.payload,
    this.caption,
    this.end,
  });

  final DownloadTaskPayload payload;
  final Widget? caption;
  final Widget? end;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (payload.hasImage)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Thumbnail(
                size: const Size.square(36),
                localThumbnailPath: payload.audioLocalThumbnailPath,
                thumbnailPath: payload.audioThumbnailPath,
                thumbnailUrl: payload.audioThumbnailUrl,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payload.audioTitle ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (caption != null) caption!,
              ],
            ),
          ),
          if (end != null) end!,
        ],
      ),
    );
  }
}
