import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/play_audio/state/now_playing_audio_state.dart';
import '../../../shared/ui/alphabet_list.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFilesAlphabet extends StatelessWidget {
  const LocalAudioFilesAlphabet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, localAudioFilesState) {
        return BlocBuilder<NowPlayingAudioCubit, NowPlayingAudioState>(
          builder: (_, nowPlayingAudioState) => localAudioFilesState.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            success: (data) => _Content(
              audios: data,
              nowPlayingAudio: nowPlayingAudioState.nowPlayingAudio.getOrNull,
            ),
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.audios,
    required this.nowPlayingAudio,
  });

  final List<Audio> audios;
  final Audio? nowPlayingAudio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlphabetList(
      keywords: audios.map((e) => e.title).toList(),
      backgroundColor: theme.colorScheme.primaryContainer,
      onIndexChanged: (value) {},
      padding: EdgeInsets.symmetric(vertical: 16.h),
      margin: EdgeInsets.only(top: 12.h, bottom: nowPlayingAudio != null ? 72.h : 12.h),
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
    );
  }
}
