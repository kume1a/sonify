import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../features/play_audio/ui/audio_player_panel.dart';
import '../../../shared/ui/alphabet_list.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/my_library_audios_state.dart';

class MyLibraryAlphabet extends StatelessWidget {
  const MyLibraryAlphabet({
    super.key,
    required this.onIndexChanged,
  });

  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyLibraryAudiosCubit, MyLibraryAudiosState>(
      builder: (_, localAudioFilesState) {
        return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
          builder: (_, nowPlayingAudioState) => localAudioFilesState.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            success: (data) => _Content(
              userAudios: data,
              nowPlayingAudio: nowPlayingAudioState.nowPlayingAudio.getOrNull,
              onIndexChanged: onIndexChanged,
            ),
          ),
        );
      },
    );
  }
}

class _Content extends HookWidget {
  const _Content({
    required this.userAudios,
    required this.nowPlayingAudio,
    required this.onIndexChanged,
  });

  final List<UserAudio> userAudios;
  final Audio? nowPlayingAudio;
  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final keywords = useMemoized(
      () => userAudios.map((e) => e.audio?.title).nonNulls.toList(),
    );

    return AlphabetList(
      keywords: keywords,
      backgroundColor: theme.colorScheme.primaryContainer,
      onIndexChanged: onIndexChanged,
      width: 18.w,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      margin: EdgeInsets.only(
        top: 12.h,
        bottom: nowPlayingAudio != null ? AudioPlayerPanel.minHeight + 12.h : 12.h,
      ),
      textStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.normal,
        color: theme.appThemeExtension?.elSecondary,
      ),
      overlayWidgetBuilder: (value) => Container(
        height: 28.w,
        width: 28.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primaryColor,
        ),
        alignment: Alignment.center,
        child: Text(
          value.toUpperCase(),
          style: TextStyle(fontSize: 15.sp),
        ),
      ),
      centerOverlayWidgetBuilder: (value) => Container(
        height: 48.w,
        width: 48.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Text(
          value.toUpperCase(),
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
