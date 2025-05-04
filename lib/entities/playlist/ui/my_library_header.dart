import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../features/play_audio/model/playback_button_state.dart';
import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/round_play_button.dart';
import '../../../shared/values/assets.dart';
import '../../audio/state/my_library_audios_state.dart';

class MyLibraryHeader extends StatelessWidget {
  const MyLibraryHeader({super.key});

  static final double height = 26.h;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
          buildWhen: (previous, current) =>
              previous.playlist != current.playlist || previous.playButtonState != current.playButtonState,
          builder: (_, state) {
            return RoundPlayButton(
              size: height,
              iconSize: 16.h,
              isPlaying: state.playlist == null && state.playButtonState == PlaybackButtonState.playing,
              onPressed: context.nowPlayingAudioCubit.onPlayLocalAudiosPressed,
            );
          },
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            l.myLibrary,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          onPressed: context.myLibraryAudiosCubit.onSortByPressed,
          icon: SvgPicture.asset(
            Assets.svgArrowDownUp,
            width: 16.w,
            height: 16.h,
          ),
          splashRadius: 24,
        ),
      ],
    );
  }
}
