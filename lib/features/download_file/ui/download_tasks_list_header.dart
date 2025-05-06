import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/downloads_state.dart';

class DownloadTasksListHeader extends StatelessWidget {
  const DownloadTasksListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<DownloadsCubit, DownloadsState>(
      builder: (_, state) {
        if (state.isEmpty) {
          return const SizedBox.shrink();
        }

        int inProgressCount = 0;
        int totalCount = 0;

        for (final task in state) {
          totalCount++;
          if (task.isInProgress) {
            inProgressCount++;
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l.downloadSummary(totalCount, inProgressCount),
          ),
        );
      },
    );
  }
}
