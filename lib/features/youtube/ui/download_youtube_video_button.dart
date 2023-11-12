import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/di/register_dependencies.dart';
import '../../../app/intl/app_localizations.dart';
import '../../../shared/util/equality.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/select_download_youtube_video_state.dart';
import '../state/youtube_video_state.dart';
import '../util/format_bitrate.dart';
import '../util/format_file_size.dart';

class DownloadYoutubeVideoButton extends HookWidget {
  const DownloadYoutubeVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final isMounted = useIsMounted();

    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) => previous.video != current.video,
      builder: (_, state) {
        return TextButton(
          child: Text(l.download),
          onPressed: () async {
            final audioOnlyStreamInfo = await showModalBottomSheet<AudioOnlyStreamInfo?>(
              context: context,
              isScrollControlled: true,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.youtubeVideoCubit),
                  BlocProvider(create: (_) => getIt<SelectDownloadYoutubeVideoCubit>()),
                ],
                child: const _DownloadYoutubeVideoBottomSheet(),
              ),
            );

            if (audioOnlyStreamInfo == null || !isMounted()) {
              return;
            }

            // ignore: use_build_context_synchronously
            context.youtubeVideoCubit.onDownloadAudioOnlyStreamInfo(audioOnlyStreamInfo);
          },
        );
      },
    );
  }
}

class _DownloadYoutubeVideoBottomSheet extends StatelessWidget {
  const _DownloadYoutubeVideoBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.downloadVideoAs,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Text(
            l.audio,
            style: TextStyle(fontSize: 12, color: theme.appThemeExtension?.elSecondary),
          ),
          const Divider(thickness: 1, height: 1),
          const _AudioOptions(),
          const SizedBox(height: 32),
          TextButton(
            onPressed: context.selectDownloadYoutubeVideoCubit.onDownloadPressed,
            child: Text(l.download),
          ),
        ],
      ),
    );
  }
}

class _AudioOptions extends StatelessWidget {
  const _AudioOptions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
      buildWhen: (previous, current) =>
          notDeepEquals(previous.audioOnlyStreamInfos, current.audioOnlyStreamInfos),
      builder: (_, state) {
        return state.audioOnlyStreamInfos.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (data) => ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (_, index) => _DownloadAudioSelectTile(
              audioStreamInfo: data[index],
            ),
          ),
        );
      },
    );
  }
}

class _DownloadAudioSelectTile extends StatelessWidget {
  const _DownloadAudioSelectTile({
    required this.audioStreamInfo,
  });

  final AudioOnlyStreamInfo audioStreamInfo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final formattedBitrate = formatBitrate(audioStreamInfo.bitrate, l);
    final formattedFileSize = formatFileSize(audioStreamInfo.size, l);

    final audioLabel = formattedBitrate;

    return InkWell(
      onTap: () => context.selectDownloadYoutubeVideoCubit.onChangeSelectedStreamInfo(audioStreamInfo),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.svgMusicNote,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                audioLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Text(formattedFileSize),
            BlocBuilder<SelectDownloadYoutubeVideoCubit, SelectDownloadYoutubeVideoState>(
              buildWhen: (previous, current) => previous.selectedStreamInfo != current.selectedStreamInfo,
              builder: (context, state) {
                return Radio(
                  value: audioStreamInfo.tag,
                  groupValue: state.selectedStreamInfo?.tag,
                  onChanged: null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
