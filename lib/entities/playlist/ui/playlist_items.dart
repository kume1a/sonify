import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/playlist_state.dart';

class PlaylistItems extends StatelessWidget {
  const PlaylistItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) {
            final len = data.playlistAudios?.length ?? 0;

            return SliverList.builder(
              itemCount: len + 1,
              itemBuilder: (_, index) {
                // bottom padding
                if (index == len) {
                  return SizedBox(height: AudioListItem.height + 12.h);
                }

                final playlistAudio = data.playlistAudios?.elementAt(index);
                if (playlistAudio == null || playlistAudio.audio == null) {
                  return const SizedBox.shrink();
                }

                return _Item(playlistAudio: playlistAudio);
              },
            );
          },
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.playlistAudio,
  });

  final PlaylistAudio playlistAudio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
      buildWhen: (previous, current) =>
          previous.nowPlayingAudio != current.nowPlayingAudio ||
          previous.canPlayRemoteAudio != current.canPlayRemoteAudio ||
          previous.playlist != current.playlist,
      builder: (_, state) {
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
          end: IconButton(
            icon: SvgPicture.asset(
              Assets.svgMenuVertical,
              colorFilter:
                  svgColor(isDisabled ? theme.appThemeExtension?.elSecondary : theme.colorScheme.onSurface),
            ),
            splashRadius: 24,
            onPressed:
                isDisabled ? null : () => context.playlistCubit.onPlaylistAudioMenuPressed(playlistAudio),
          ),
        );
      },
    );
  }
}
