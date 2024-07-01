import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';

class PlaylistListItem extends StatelessWidget {
  const PlaylistListItem({
    super.key,
    required this.playlistAudio,
    this.onMenuPressed,
  });

  final PlaylistAudio playlistAudio;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) =>
          previous.nowPlayingAudio != current.nowPlayingAudio ||
          previous.canPlayRemoteAudio != current.canPlayRemoteAudio ||
          previous.playlist != current.playlist,
      builder: (_, state) {
        if (playlistAudio.audio == null) {
          return const SizedBox.shrink();
        }

        final nowPlayingAudio = state.nowPlayingAudio.getOrNull;

        final isPlaying = nowPlayingAudio?.id != null &&
            nowPlayingAudio?.id == playlistAudio.audioId &&
            state.playlist != null &&
            state.playlist?.id == playlistAudio.playlistId;

        final canPlayRemoteAudio = state.canPlayRemoteAudio.dataOrElse(() => false);
        final isDisabled = !canPlayRemoteAudio && playlistAudio.audio?.localPath == null;

        return AudioListItem(
          onTap: () => context.nowPlayingAudioCubit.onPlaylistAudioPressed(playlistAudio),
          audio: playlistAudio.audio!,
          isPlaying: isPlaying,
          isDisabled: isDisabled,
          padding: EdgeInsets.only(left: 16.r),
          showDownloadedIndicator: true,
          end: onMenuPressed != null
              ? IconButton(
                  icon: SvgPicture.asset(
                    Assets.svgMenuVertical,
                    colorFilter: svgColor(
                        isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onSurface),
                  ),
                  splashRadius: 24,
                  onPressed: isDisabled ? null : onMenuPressed,
                )
              : null,
        );
      },
    );
  }
}
