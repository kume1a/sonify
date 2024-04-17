import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/error_intl.dart';
import '../state/youtube_video_state.dart';

class DownloadYoutubeAudioErrorText extends StatelessWidget {
  const DownloadYoutubeAudioErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) => previous.downloadAudioState != current.downloadAudioState,
      builder: (_, state) {
        return state.downloadAudioState.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          failed: (err) => Text(
            err.translate(l),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      },
    );
  }
}
