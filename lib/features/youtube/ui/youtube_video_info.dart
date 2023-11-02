import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../shared/values/app_theme_extension.dart';
import '../state/youtube_video_state.dart';

class YoutubeVideoInfo extends StatelessWidget {
  const YoutubeVideoInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) => previous.video != current.video,
      builder: (_, state) {
        return state.video.maybeWhen(
          success: (data) => _Content(data),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.data);

  final Video data;

  static final _numberFormat = NumberFormat.compactLong();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Logger.root.info(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.title),
        const SizedBox(height: 2),
        Text(
          descriptionLabel,
          style: TextStyle(
            fontSize: 12,
            color: theme.appThemeExtension?.elSecondary,
          ),
        ),
      ],
    );
  }

  String get descriptionLabel {
    String label = data.author;

    final viewCountLabel = _numberFormat.format(data.engagement.viewCount);
    label += ' · $viewCountLabel';

    if (data.uploadDate != null) {
      final timeagoLabel = timeago.format(data.uploadDate!);
      label += ' · $timeagoLabel';
    }

    return label;
  }
}
