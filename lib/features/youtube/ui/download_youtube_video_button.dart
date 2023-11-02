import 'package:flutter/material.dart';

import '../../../app/intl/app_localizations.dart';

class DownloadYoutubeVideoButton extends StatelessWidget {
  const DownloadYoutubeVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return TextButton(
      child: Text(l.download),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => const _DownloadYoutubeVideoBottomSheet(),
        );
      },
    );
  }
}

class _DownloadYoutubeVideoBottomSheet extends StatelessWidget {
  const _DownloadYoutubeVideoBottomSheet();

  @override
  Widget build(BuildContext context) {
    return const Text('Bottom sheet');
  }
}
