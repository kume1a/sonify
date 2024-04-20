import 'package:flutter/material.dart';

import '../app/intl/app_localizations.dart';
import '../features/download_file/ui/downloaded_tasks_list.dart';
import '../features/download_file/ui/downloading_tasks_list.dart';
import '../shared/ui/list_header.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.downloads),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ListHeader(
                text: l.downloads,
              ),
            ),
            const DownloadingTasksList(),
            SliverToBoxAdapter(
              child: ListHeader(
                text: l.downloaded,
              ),
            ),
            const DownloadedTasksList(),
          ],
        ),
      ),
    );
  }
}
