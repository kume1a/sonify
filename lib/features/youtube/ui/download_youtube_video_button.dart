import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/youtube_video_state.dart';

class DownloadYoutubeVideoButton extends StatelessWidget {
  const DownloadYoutubeVideoButton({
    super.key,
    required this.videoId,
  });

  final String videoId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) => previous.video != current.video,
      builder: (_, state) {
        return TextButton(
          onPressed: context.youtubeVideoCubit.onDownloadAudio,
          child: Text(l.downloadAudio),
        );
      },
    );
  }
}
