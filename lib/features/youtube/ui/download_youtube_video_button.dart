import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/error_intl.dart';
import '../../../shared/ui/loading_text_button.dart';
import '../state/youtube_video_state.dart';

class DownloadYoutubeVideoButton extends StatelessWidget {
  const DownloadYoutubeVideoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) =>
          previous.isDownloadAvailable != current.isDownloadAvailable ||
          previous.downloadAudioState != current.downloadAudioState,
      builder: (_, state) {
        return Column(
          children: [
            LoadingTextButton(
              onPressed: state.isDownloadAvailable ? context.youtubeVideoCubit.onDownloadAudio : null,
              label: l.downloadAudio,
              isLoading: state.downloadAudioState.isExecuting,
            ),
            state.downloadAudioState.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              failed: (err) => Text(
                err.translate(l),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            )
          ],
        );
      },
    );
  }
}
